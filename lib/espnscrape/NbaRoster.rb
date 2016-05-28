# Access NBA roster data

class NbaRoster
	include NbaUrls

	# Return coach Name
	# @return [String] Coach Name
	# @example
	# 	r.coach #=> "Jerry Sloan"
	attr_reader :coach

	# Returns Team Roster
	# @return [[[String]]] 2d Array of Players
	# @note Roster Row :  [TeamId, Jersey #, Player Name, ESPN Player ID, Position, Age, Height ft, Height in, Weight, College, Salary]
	attr_reader :players

	# Scrape Roster Data
	# @param team_id [String] Three letter TeamID
	# @example
	# 	r = NbaRoster.new("UTA")
	def initialize(team_id)
		unless (team_id == '')
			url = formatTeamUrl(team_id, teamRosterUrl)  # Generate URL
			doc = Nokogiri::HTML(open(url))				   		 # Get DOM
			if doc.nil?																	 # Error gracefully
				return []
			end
			list = doc.xpath('//div/div/table/tr')
			pList = list[2,list.length-3]				  	     # Get Player Nodes

			@coach = list[list.length - 1].children[0].text.split(':')[1].strip  # Read Coach Name
			@players = []
			pList.each do |row|
				cnt = 0
				tmp = []
				tmp << team_id  									  #Team ID
				row.children.each do |cell|
					txt = cell.text.chomp.strip
					case cnt
					when 0, 2, 3, 5	 									# 0 Player No, 2 Position, 3 Age, 5 Weight
						tmp << txt
					when 1 														# Player Name
						tmp << txt.gsub("'","\'")
						tmp << cell.children[0].attribute("href").text[/id\/(\d+)/, 1] # Player ID
					when 4													  # Player Height
						tmp.concat(txt.split('-'))
					when 6 														# College
						tmp << txt.gsub("'","\'").strip
					when 7 														# Salary
						# Remove extraneous symbols
						txt = txt.gsub('$','')
						txt = txt.gsub(',','').strip()
						tmp << (txt.length > 1 ? txt : 0)  # Store Positive Salary (Default: 0)
					end
					cnt += 1
				end
				if !tmp.nil?
					@players << tmp
				end
			end
			return @players
		end
	end

	# CSV String representation
	# @return [String]
	def toString()
		res = ''
		@players.each do |p|
			res = res + p.join(',')
		end
	end
end
