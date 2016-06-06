# Access NBA roster data
class NbaRoster
	include NbaUrls
	include DebugUtils

	# @return [String] Coach Name
	attr_reader :coach

	# Returns Team Roster
	# @return [[[String]]] Player List Table ({EspnScrape::FS_ROSTER Row Description})
	# @see EspnScrape::FS_ROSTER
	attr_reader :players

	# Scrape Roster Data
	# @param team_id [String] Team ID
	# @example
	# 	r = NbaRoster.new("UTA")
	# 	r = NbaRoster.new('', 'test/rosterData.html')
	def initialize(team_id, file='')
		if (!team_id.empty?)
			url = formatTeamUrl(team_id, teamRosterUrl)  # Generate URL
			doc = Nokogiri::HTML(open(url))				   		 # Get DOM
		elsif (!file.empty?)
			doc = Nokogiri::HTML(open(file))
		end
		exit if doc.nil?

		team_id = getTid(doc.title.split(/\d{4}/)[0].strip) if team_id.empty?

		list  = doc.xpath('//div/div/table/tr')
		pList = list[2,list.length-3]				  	     # Get Player Nodes

		@coach   = list[list.length - 1].children[0].text.split(':')[1].strip  # Read Coach Name
		@players = processPlayerTable(pList, team_id)
	end

	private
	# Collect Roster Data
	# @param table [[Nokogiri::XML::NodeSet]] Roster Table
	# @param team_id [String] Team ID
	# @return [[[String]]] Processed Roster Data
	def processPlayerTable(table, team_id)
		result = []
		table.each do |row|
			tmp = [team_id]											# Start row with Team ID
			row.children.each_with_index do |cell, cnt|
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
					txt.delete!('$').delete!(',').strip!
					tmp << (txt.length > 1 ? txt : 0)  # Store Positive Salary (Default: 0)
				end
			end
			result << tmp
		end
		return result
	end
end
