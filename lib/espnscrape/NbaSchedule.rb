# Access NBA team schedule data
class NbaSchedule
	include NbaUrls
	require_relative 'Util.rb'

	attr_reader :game_list, :next_game

	# Read Schedule data for a given Team
	# @param tid [String] Team ID
	# @param file [String] HTML Test Data
	# @param seasontype [Integer] Season Type
	# @note
	#  Season Types: 1-Preseason; 2-Regular Season; 3-Playoffs
	# @example
	# 	test     = NbaSchedule.new('', 'test/testData.html')
	# 	pre      = NbaSchedule.new('UTA', '', 1)
	# 	playoffs = NbaSchedule.new('GSW', '', 3)
	def initialize(tid, file='', seasontype='')
		doc = ''
		if file.empty? # Load Live Data
			unless (tid.empty?)
				url = formatTeamUrl(tid, teamScheduleUrl(seasontype))
				doc = Nokogiri::HTML(open(url))
			end
		else # Load File Data
			doc = Nokogiri::HTML(open(file))
		end

		schedule = doc.xpath('//div/div/table/tr') #Schedule Rows
		year1 = doc.xpath('//div[@id=\'my-teams-table\']/div/div/div/h1').text.split('-')[1].strip.to_i #Season Starting Year
		season_indicator = doc.xpath("//tr[@class='stathead']").text.split[1].downcase # preseason/regular/postseason

		@game_list = []
		@next_game = 0 # Cursor to start of Future Games

		# If season type is provided, verify
		case seasontype
		when 1
			if !season_indicator.include?("pre")
				return nil
			end
		when 2
			if !season_indicator.include?("regular")
				return nil
			end
		when 3
			if !season_indicator.include?("post")
				return nil
			end
		else
			# When no season type is provided, determine season type
			if season_indicator.include?("pre")
				seasontype = 1
			elsif season_indicator.include?("regular")
				seasontype = 2
			elsif season_indicator.include?("post")
				seasontype = 3
			else
				return nil
			end
		end
		processSeason(schedule, tid, year1, seasontype)

	end

	# @return [[[String]]] Table of All Schedule data
	# @see EspnScrape::FS_SCHEDULE_FUTURE
	# @see EspnScrape::FS_SCHEDULE_PAST
	def getAllGames
		return @game_list
	end

	# Returns Schedule info of next game
	# @return [[String]] Future Schedule Row ({EspnScrape::FS_SCHEDULE_FUTURE Description})
	# @note (see #getFutureGames)
	# @example
	# 	getNextGame() #=> ["GSW", 19, false, 0, "Jun 5", true, "CLE", "8:00 PM ET", true, "2016-06-05 20:00:00", 3]
	def getNextGame
		return @game_list[@next_game]
	end

	# Returns Schedule info of last completed game
	# @return [[String]] Past Schedule Row ({EspnScrape::FS_SCHEDULE_PAST Description})
	# @note (see #getPastGames)
	# @example
	# 	getLastGame() #=> ["UTA", 82, "00:00:00", false, "Apr 13", false, "LAL", false, "96", "101", "400829115", "40", "42", "2016-04-13 00:00:00", 2]
	def getLastGame
		return @game_list[@next_game-1]
	end

	# @return [Integer] Game # of Next Game
	def getNextGameId
		return @next_game
	end

	# @return [String] Team ID of next opponent
	# @example
	#   getNextTeamid() #=> "OKC"
	def getNextTeamId
		gameIndex = 6
		return getNextGame[gameIndex]
	end

	# @return [[String]] Table of Future Games ({EspnScrape::FS_SCHEDULE_FUTURE Description})
	# @note (see EspnScrape::FS_SCHEDULE_FUTURE)
	def getFutureGames
		return @game_list[@next_game, game_list.size]
	end

	# Return Schedule info of Past Games
	# @return [[String]] Table of Past Games ({EspnScrape::FS_SCHEDULE_PAST Description})
	# @note (see EspnScrape::FS_SCHEDULE_PAST)
	def getPastGames
		return @game_list[0, @next_game]
	end

	private

	def processSeason(schedule, tid, year1, seasontype)
		year2 = year1 + 1 # Season Ending Year
		game_id = 0 # 82-game counter
		gameDate = ""
		game_time = ""
		row_type = ''
		ws = 0
		ls = 0
		win = ''

		# Process Schedule lines
		schedule.each do |x|
			if ('a'..'z').include?(x.children[0].text[1,1]) # Non-Header Row
				if x.children[2].text.include?(":")           # Special Case - Future Playoff games shown under 'Result' header
					row_type = 'F'
				end
				tmp = [] 				# Table of Schedule rows
				tmp << tid			# TeamID
				game_id += 1
				tmp << game_id   # GameID

				cnt = 0
				columns = x.children.size
				if ( columns == 3 )
					# =>  Postponed
					game_id -= 1
					next
				elsif row_type == 'F'
					# => Future Game
					tmp << false 								#Win
					tmp << 0							  		#boxscore_id
					x.children.each do |cell|
						if cnt < 4
							txt = cell.text.chomp
							if cnt == 0 						# Game Date
								gameDate = txt.split(',')[1].strip
								tmp << gameDate
							elsif cnt == 1 				 # Home/Away, Opp tid
								if txt[0,1].include?('@') # Home?
									tmp << false
								else
									tmp << true
								end
								x1 = cell.children.children.children[1].attributes['href'].text.split('/')[-1].split('-').join(' ')
								tmp << getTid(x1) 	# OppID
							elsif cnt == 2 				# Game Time
								game_time = txt + ' ET'
								tmp << game_time
							elsif cnt == 3 				# TV
								if cell.children[0].node_name == 'img' || txt != " "
									tmp << true
								else
									tmp << false
								end
							end
						end
						cnt += 1
					end
				else
					# => Past Game
					game_time = '00:00:00' 		# Game Time (Not shown for past games)
					tmp << game_time
					tmp << false 						  # TV (NS)
					x.children.each do |cell|
						if cnt <= 3
							txt = cell.text.chomp
							if cnt == 0 				 # Game Date
								gameDate = txt.split(',')[1].strip
								tmp << gameDate
							elsif cnt == 1
								if txt[0,1].include?('@') # Home?
									tmp << false
								else
									tmp << true
								end
								x0 = cell.children.children.children[1].attributes['href']
								if x0.nil? # Non-NBA Team
									tmp << cell.children.children.children[1].text.strip
								else # NBA Team
									x1 = x0.text.split('/')[-1].split('-').join(' ')
									tmp << getTid(x1) 				# OppID
								end
							elsif cnt == 2 						  # Game Result
								win =  (txt[0,1].include?('W') ? true : false)
								tmp << win 								# Win?
								txt2 = txt[1, txt.length].gsub(/\s?\d?OT/,'')
								if !win
									opp_score, team_score = txt2.split('-')
								else
									team_score, opp_score = txt2.split('-')
								end
								tmp << team_score << opp_score #Team Score, Opp Score
								x0 = cell.children.children.children[1].attributes['href']
								if x0.nil?
									tmp << 0
								else
									bs_id = x0.text.split('=')[1]
									tmp << bs_id 												# Boxscore ID
								end
							elsif cnt == 3 && seasontype != 3			#Team Record
								wins, losses = txt.split('-')
								tmp << wins << losses
							elsif cnt == 3 && seasontype == 3			#Team Record Playoffs
								win ? ws += 1 : ls +=1
								tmp << ws << ls
							end
						end
						cnt += 1
						@next_game = game_id
					end
				end
			else # Header Row
				if x.children.size < 2
					next
				elsif x.children[2].text.include?("TIME")
					row_type = 'F'
				elsif x.children[2].text.include?("RESULT")
					row_type = 'P'
				end
			end

			# => Adjust and format dates
			if !tmp.nil?
				if ['Oct', 'Nov', 'Dec'].include?(gameDate.split[0])
					d = DateTime.parse(game_time + ' , ' + gameDate + "," + year1.to_s)
				else
					d = DateTime.parse(game_time + ' , ' + gameDate + "," + year2.to_s)
				end
				# puts "GameDate = %s" % [d.strftime("%Y-%m-%d %H:%M:%S")]
				gameDate = d.strftime("%Y-%m-%d %H:%M:%S")
				tmp << gameDate # Game DateTime

				tmp << seasontype # Season Type

				# => Store row
				@game_list << tmp
			end
		end
	end
end
