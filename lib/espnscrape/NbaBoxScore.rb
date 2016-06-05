require_relative 'Util.rb'
# Access NBA boxscore data
class NbaBoxScore
	include NbaUrls
	include Util

	# @return [String] Game Date
	attr_accessor :gameDate

	# @return [String] Away Team Name
	attr_accessor :awayName

	# @return [[[Integer]]] Away Team Stats Array
	# @see EspnScrape::FS_BOXSCORE
	attr_accessor :awayPlayers

	# @return [[Integer]] Away Team Combined Stats
	# @see EspnScrape::FS_BOXSCORE_TOTALS
	attr_accessor :awayTotals

	# @return [String] Home Team Name
	attr_accessor :homeName

	# @return [[[Integer]]] Home Team Stats Array
	# @see EspnScrape::FS_BOXSCORE
	attr_accessor :homePlayers

	# @return [[Integer]] Home Team Combined Stats
	# @see EspnScrape::FS_BOXSCORE_TOTALS
	attr_accessor :homeTotals

	# Scrape Box Score Data
	# @param game_id [Integer] Boxscore ID
	# @example
	# 	bs = NbaBoxScore.new(400828035)
	def initialize(game_id)
		unless (game_id.nil?)
			url = boxScoreUrl + game_id.to_s
			doc = Nokogiri::HTML(open(url))
			if doc.nil?
				puts "URL Unreachable: " + url
				exit 1
			end

			@gameDate = readGameDate(doc)
			@awayName, @homeName = readTeamNames(doc)
			if(@gameDate.index("00:00:00")) # Only past games have stats
				@awayPlayers, @awayTotals = readTeamStats(doc, 'away')
				@homePlayers, @homeTotals = readTeamStats(doc, 'home')
			end
		end
	end

	# Print a totals row
	# @param teamTotals [[Integer]] Team Totals
	def printTotals(teamTotals, colWidth=5)
		printTable([teamTotals], colWidth, 'Team Totals')
	end

	private

	# Reads the game date from a Nokogiri::Doc
	# @param d [Nokogiri::HTML::Document]
	# @return [String] Game date
	# @example
	# 	bs.readGameDate(doc) #=> "Mon, Nov 23"
	# @note
	# 	Times will be Local to the system Timezone
	#
	def readGameDate(d)
		# Should be YYYY-MM-DD HH:MM:00
		time = d.xpath('//span[contains(@class,"game-time")]')[0].text.strip
		date = d.title.split('-')[2].gsub(',', "")

		# Future game time is populated via AJAX, so may not be available at the
		# time the HTML is processed
		if(time.empty?)
			utc_datetime = d.xpath('//span[contains(@class,"game-time")]/parent::span').first.attribute("data-date").text
			utc_datetime = DateTime.parse(utc_datetime).new_offset(DateTime.now.offset)
			return utc_datetime.strftime("%Y-%m-%d %H:%M:%S")
		end

		# Past games have no displayed time
		if(time == 'Final')
			time = "00:00:00"
		end

		return DateTime.parse(date + " " + time).strftime("%Y-%m-%d %H:%M:%S")
	end


	# Reads the team names from a Nokogiri::Doc
	# @param d [Nokogiri::HTML::Document]
	# @return [String, String] Team 1, Team 2
	# @example
	# 	bs.readGameDate(doc)
	#
	def readTeamNames(d)
		names = d.xpath('//div[@class="team-info"]/*/span[@class="long-name" or @class="short-name"]')
		away = names[0].text + " " + names[1].text
		home = names[2].text + " " + names[3].text
		return [away, home]
	end


	# Reads the team stats from a Nokogiri::Doc
	# @param d [Nokogiri::HTML::Document]
	# @param id [String] Team selector -> home/away
	# @return [String] Game date
	# @example
	# 	bs.readTeamStats(doc,'away')
	#
	def readTeamStats(d, id)
		#Extract player tables
		p_tables = d.xpath('//div[@class="sub-module"]/*/table/tbody')
		if(p_tables.nil? or p_tables.empty?)
			puts "No Game Data Available"
			return [],[]
		end

		if id == 'away'
			p_tab = p_tables[0,2]
			tid = getTid(@awayName)
		else
			p_tab = p_tables[2,4]
			tid = getTid(@homeName)
		end

		player_rows = p_tab.xpath('tr[not(@class)]') 				# Ignore TEAM rows
		team_row = p_tab.xpath('tr[@class="highlight"]')[0] # Ignore TEAM rows

		player_stats = []								# Array of processed data
		row_count = 0									  # Starter Tracker

		player_rows.each do |row|			  # Process Rows
			tmp_array = Array.new					# Array of data being processed
			tmp_array << tid 						  # team_id
			tmp_array << '0' 					    # game_id

			row.children.each do |cell|		# Process Columns
				c_val = cell.text.strip
				case cell.attribute("class").text
				when "name"
					tmp_array << cell.children[0].attribute("href").text[/id\/(\d+)/, 1] # Player ID
					tmp_array << cell.children[0].text.strip # Player Short Name (i.e. D. Wade)
					tmp_array << cell.children[1].text.strip # Position
				when 'fg', '3pt', 'ft'
					# Made, Attempts
					cell.text.split('-').each do |sp|
						tmp_array << sp.strip.gsub("\'","\\\'")
					end
				else
					tmp_array << c_val
				end
			end

			if(row_count < 5)   # Check if Starter
				tmp_array << "X"
			end

			player_stats << tmp_array # Save processed data
			row_count += 1 			# Starter Tracker
		end

		# Extract TEAM stats
		team_totals = Array.new
		team_row.children.each do |cell|
			c_val = cell.text.strip
			case cell.attribute("class").text
			when 'name'
				team_totals << tid
			when 'fg', '3pt', 'ft'
				# Made, Attempts
				cell.text.split('-').each do |sp|
					team_totals << sp.strip.gsub("\'","\\\'")
				end
			else
				if(c_val.empty?)
					next
				end
				team_totals << c_val
			end
		end

		return player_stats, team_totals
	end
end
