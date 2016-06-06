# Access NBA team schedule data
class NbaSchedule
	include NbaUrls
	include DebugUtils

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
		if file.empty? # Load Live Data
			unless (tid.empty?)
				url = formatTeamUrl(tid, teamScheduleUrl(seasontype))
				doc = Nokogiri::HTML(open(url))
			end
		else # Load File Data
			doc = Nokogiri::HTML(open(file))
		end
		exit if doc.nil?

		schedule = doc.xpath('//div/div/table/tr') #Schedule Rows
		year1 = doc.xpath('//div[@id=\'my-teams-table\']/div/div/div/h1').text.split('-')[1].strip.to_i #Season Starting Year
		season_indicator = doc.xpath("//tr[@class='stathead']").text.split[1].downcase # preseason/regular/postseason
		if tid.empty?
			tid = getTid(doc.title.split(/\d{4}/)[0].strip)
		end

		@game_list = []
		@next_game = 0 # Cursor to start of Future Games

		seasonValid = verifySeasonType(seasontype, season_indicator)
		seasontype  = findSeasonType(season_indicator) if seasontype.empty?

		processSeason(schedule, tid, year1, seasontype) if seasonValid && !seasontype.nil?

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

	# Ensure requested season type is what is being processed
	def verifySeasonType(type, indicator)
		# If season type is provided, verify
		case type
		when 1
			return false if !indicator.include?("pre")
		when 2
			return false if !indicator.include?("regular")
		when 3
			return false if !indicator.include?("post")
		end
		return true
	end

	# Determine season type from document data
	def findSeasonType(indicator)
		# Determine season type
		return 1 if indicator.include?("pre")
		return 2 if indicator.include?("regular")
		return 3 if indicator.include?("post")
		return nil
	end

	# Process Table of Schedule Data
	def processSeason(schedule, tid, year1, seasontype)
		game_date, game_time = '', ''
		row_type  = ''		# (F)uture Game, (P)ast Game
		game_id = 0       # 82-game counter
		ws = ls	= 0			  # Playoff Win/Loss Counters

		# Process Schedule lines
		schedule.each do |row|
			if ('a'..'z').include?(row.children[0].text[1]) # Non-Header Row
				row_type = 'F' if row.children[2].text.include?(":")  # Special Case - Future Playoff games shown under 'Result' header

				tmp = [] 							# Processed row data
				tmp << tid						# TeamID
				tmp << game_id += 1   # GameID

				if row.children.size == 3                  # => Postponed Game
					game_id -= 1
					next
				elsif row_type == 'F' 			               # => Future Game
					game_date, game_time = futureGame(row, tmp)
				else											                 # => Past Game
					@next_game = game_id
					game_time = '00:00:00' # Game Time (Not shown for past games)
					tmp << game_time
					tmp << false 					 # TV (NS)
					game_date, ws, ls = pastGame(row, tmp, ws, ls, seasontype)
				end
			else # Header Row
				next if row.children.size < 2
				row_type = 'F' if row.children[2].text.include?("TIME")
				row_type = 'P' if row.children[2].text.include?("RESULT")
			end

			if !tmp.nil?
				tmp << formatGameDate(game_date, year1, game_time) # Game DateTime
				tmp << seasontype 										 						 # Season Type
				@game_list << tmp											 						 # Save processed row
			end
		end
	end

	# Process Past Game Row
	def pastGame(row, result, ws, ls, seasonType)
		row.children.each_with_index do |cell, cnt|
			if cnt <= 3
				txt = cell.text.chomp
				if cnt == 0 				 									# Game Date
					result << txt.split(',')[1].strip
				elsif cnt == 1 			 									# Home Game? and Opponent ID
					saveHomeOpponent(cell, result, txt)
				elsif cnt == 2 			 									# Game Result
					saveGameResult(cell, result, txt)
				elsif cnt == 3 && seasonType != 3			# Team Record
					wins, losses = txt.split('-')
					result << wins << losses
				elsif cnt == 3 && seasonType == 3			# Team Record Playoffs
					result[7] ? ws += 1 : ls +=1
					result << ws << ls
				end
			end
		end
		# 		 Game Date, wins, losses
		return result[4], ws, ls
	end

	# Process Future Game Row
	def futureGame(row, result)
		result << false 							#Win
		result << 0							  		#boxscore_id
		row.children.each_with_index do |cell, cnt|
			if cnt < 4
				txt = cell.text.strip
				if cnt == 0 						  # Game Date
					result << txt.split(',')[1].strip
				elsif cnt == 1 				    # Home/Away, Opp tid
					saveHomeOpponent(cell, result, txt)
				elsif cnt == 2 				    # Game Time
					result << txt + ' ET'
				elsif cnt == 3 			    	# TV
					if (['a','img'].include?(cell.children[0].node_name) || txt.size > 1)
						result << true
					else
						result << false
					end
				end
			end
		end
		# 		 Game Date, Game Time
		return result[4], result[7]
	end

	# Store Home? and Opponent ID
	def saveHomeOpponent(cell, result, txt)
		txt[0,1].include?('@') ? result << false : result << true      # Home Game?
		x0 = cell.children.children.children[1].attributes['href']
		if x0.nil? # Non-NBA Team
			result << cell.children.children.children[1].text.strip
		else 			 # NBA Team
			result << getTid(x0.text.split('/')[-1].split('-').join(' ')) # Opponent ID
		end
	end

	# Store Game Result
	# Win?, Team Score, Opponent Score, Boxscore ID
	def saveGameResult(cell, result, txt)
		win = (txt[0,1].include?('W') ? true : false)
		final_score = txt[1, txt.length].gsub(/\s?\d?OT/,'')
		if win
			team_score, opp_score = final_score.split('-')
		else
			opp_score, team_score = final_score.split('-')
		end
		boxID = cell.children.children.children[1].attributes['href']

		result << win << team_score << opp_score # Win?, Team Score, Opponent Score
		boxID.nil? ? result << 0 : result << boxID.text.split('=')[1] # Boxscore ID
	end


	#  Adjust and format dates
	def formatGameDate(month_day, year, game_time='00:00:00')
		if ['Oct', 'Nov', 'Dec'].include?(month_day.split[0])
			d = DateTime.parse(game_time + ' , ' + month_day + "," + year.to_s)
		else
			d = DateTime.parse(game_time + ' , ' + month_day + "," + (year + 1).to_s)
		end

		return d.strftime("%Y-%m-%d %H:%M:%S") # Game DateTime String
	end

end
