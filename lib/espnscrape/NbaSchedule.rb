# Access NBA team schedule data
class NbaSchedule
	include NbaUrls

	attr_reader :game_list, :next_game

	# Read Schedule data for a given Team
	# @param tid [String] Three letter TeamID
	# @param file [String] file name for static data
	# @example
	# 	t = NbaSchedule.new('', 'test/testData.html')
	# 	u = NbaSchedule.new('UTA')
	def initialize(tid='', file='')
		doc = ''
		if file.empty? # Load Live Data
			unless (tid.empty?)
				url = formatTeamUrl(tid, teamScheduleUrl)
				doc = Nokogiri::HTML(open(url))
			end
		else # Load File Data
			doc = Nokogiri::HTML(open(file))
		end

		schedule = doc.xpath('//div/div/table/tr') #Schedule Rows
		year1 = doc.xpath('//div[@id=\'my-teams-table\']/div/div/div/h1').text.split('-')[1].strip.to_i #Season Starting Year

		year2 = year1 + 1 # Season Ending Year
		game_id = 0 # 82-game counter
		gameDate = ""
		game_time = ""

		@game_list = []
		@next_game = 0 # Cursor to start of Future Games

		# Process Schedule lines
		schedule.each do |x|
			if ('a'..'z').include?x.children[0].text[1,1]
				tmp = [] 				# Table of Schedule rows
				tmp << tid			# TeamID
				game_id += 1
				tmp << game_id   # GameID

				cnt = 0
				if (x.children.size < 7)
					# => Future Game
					tmp << false 								#Win
					tmp << 0							  #boxscore_id
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
								x1 = cell.children.children.children[1].attributes['href'].text.split('/')[-1].split('-').join(' ')
								tmp << getTid(x1) 				# OppID
							elsif cnt == 2 						  # Game Result
								win =  (txt[0,1].include?('W') ? true : false)
								tmp << win 								# Win?
								txt2 = txt[1, txt.length].gsub(' OT','')
								if !win
									opp_score, team_score = txt2.split('-')
								else
									team_score, opp_score = txt2.split('-')
								end
								tmp << team_score << opp_score #Team Score, Opp Score

								bs_id = cell.children.children.children[1].attributes['href'].text.split('=')[1]
								tmp << bs_id 									# Boxscore ID
							elsif cnt == 3 								  #Team Record
								wins, losses = txt.split('-')
								tmp << wins << losses
							end
						end
						cnt += 1
						@next_game = game_id
					end
				end
			end
			if !tmp.nil?
				# => Adjust and format dates
				if ['Oct', 'Nov', 'Dec'].include?(gameDate.split[0])
					d = DateTime.parse(game_time + ' , ' + gameDate + "," + year1.to_s)
				else
					d = DateTime.parse(game_time + ' , ' + gameDate + "," + year2.to_s)
				end
				# puts "GameDate = %s" % [d.strftime("%Y-%m-%d %H:%M:%S")]
				gameDate = d.strftime("%Y-%m-%d %H:%M:%S")
				tmp << gameDate # Game DateTime

				# => Skip Postponed Games
				if game_time.include? 'Postponed'
					game_id -= 1
					next
				else
					game_time = d.strftime('%T')
				end

				# => Store row
				@game_list << tmp
			end
		end
	end

	# Return Full Schedule
	# @return [[[String]]] 2d array of Schedule data
	# @note (see #getFutureGames)
	# @note (see #getPastGames)
	def getAllGames
		return @game_list
	end

	# Return Schedule Info of next game
	# @return [[[String]]] 2d array of Future Schedule data
	# @note (see #getFutureGames)
	# @example
	# 	getNextGame() #=> ["UTA", 13, false, "NULL", "Nov 23", true, "OKC", "9:00PM", false]
	def getNextGame
		return @game_list[@next_game]
	end

	# Return Schedule Info of last completed game
	# @return [[String]] 2d array of Past Schedule data
	# @note (see #getPastGames)
	# @example
	# 	getLastGame() #=> ["UTA", 12, "00:00:00", false, "Nov 20", false, "DAL", false, "93", "102", "400828071", "6", "6"]
	def getLastGame
		return @game_list[@next_game-1]
	end

	# Return GameID of Next Game
	# @return [Integer]
	def getNextGameId
		return @next_game
	end

	# Return TeamID of next opponent
	# @return [String]
	# @example
	#   getNextTeamid() #=> "OKC"
	def getNextTeamId
		gameIndex = 6
		return getNextGame[gameIndex]
	end

	# Return Schedule info of Future Games
	# @return [[object]]
	# @note Future Games Layout: TeamID, GameID, Win?, boxscore_id, Game Date, Home?, OppID, Game Time, TV?, game_datetime
	def getFutureGames
		return @game_list[@next_game, game_list.size]
	end

	# Return Schedule info of Past Games
	# @return [[object]]
	# @note Past Games Layout: TeamID, GameID, Game Time, TV?, Game Date, Home?, OppID, Win?, Team Score, Opp Score, boxscore_id, wins, losses, game_datetime
	def getPastGames
		return @game_list[0, @next_game]
	end

	# Visualization Helper
	# @return [String]
	def toString
		str = ''
		@game_list.each do |game|
			str = str + game.join(',')
		end
		return str
	end
end
