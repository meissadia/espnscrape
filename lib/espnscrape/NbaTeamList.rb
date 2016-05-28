# Access NBA team list
class NbaTeamList
	include NbaUrls
	# Return header
	# @return [String] header
	attr_accessor :header

	# Return teamList
	# @return [[[String]]] teamList
	# @example
	#   tl.teamList =>  [Team 0][TeamID, TeamName, TeamDiv, TeamConf]
	attr_accessor :teamList

	# Populate class attributes with Team Data
	# @return [[String]] Resulting Team List
	def initialize()

		url = teamListUrl 							# Open static URL
		doc = Nokogiri::HTML(open(url))
		if doc.nil?
			puts "NbaTeamList URL Unreachable: " + url
			return nil
		end

		# Define XPATH variables
		xpath_tname = "//h5/a/text()"
		xpath_division = "//div/div/div/div/div[2]"

		# Collect
		@header = doc.xpath("//h2")[0].text.strip # Table Header
		team_names = doc.xpath(xpath_tname) # Team Names

		# Check if Division layout has changed
		divCheck = 10
		divAct = doc.xpath(xpath_division).size
		if divAct != divCheck
			# puts "Warning: Found %i out of %i divisions via xpath" % [divAct, divCheck]
		end

		@teamList = []
		h = 0 # Head of teamNames range
		west_conf = ['Northwest','Pacific','Southwest'] # Western Conference Divs
		# Process Teams by Division
		divs = ['Atlantic', 'Pacific','Central','Southwest','Southeast','Northwest']
		divs.each do |div|
			processTeams(div, team_names[h,5], west_conf, @teamList) # Store Team Data
			h += 5
		end
		# Validate teamList
		if !@teamList.nil? && @teamList.size != 30
			puts "NbaTeamList: %i teams collected!" % [@teamList.size]
		end
	end


	# Generate String representation of Team List
	# @return [String] Resulting team list string
	def toString
		res = ""
		@teamList.each do |t|
			res += t.join(',') + "\n"
		end
		return res
	end

	private

	# Derive TeamID, Division, Conference
	# @param division [String] Division Name
	# @param team_names [[String]] List of Team Names
	# @param west_conf [[String]] List of Divisions in the Western Conference
	# @param tl [[String]] List to which rows of TeamList are appended
	# @example
	# 	processTeams("Atlantic", ["Boston Celtics"], [...], result)
	# 	#result[n] = [TeamID, TeamName, TeamDiv, TeamConf]
	# 	result[0] = ["BOS", "Boston Celtics", "Atlatic", "Eastern"]
	def processTeams(division, team_names, west_conf, tl)
		# Derive Team Abbrevation
		team_names.each do |tname|
			t = tname.text # Extract text
			# Identify Team Abbreviation
			name_words = t.split
			abbr = ""
			if name_words.size > 2
				name_words.each do |x|
					abbr << x[0]
				end
				abbr.upcase
			else
				abbr = name_words[0][0..2].upcase
			end

			# Adjust Outlier Abbreviations
			case abbr
			when 'OCT'
				abbr = 'OKC'
			when 'PTB'
				abbr = 'POR'
			when 'BRO'
				abbr = 'BKN'
			end

			# Stage Team Data
			tmp = []
			tmp << abbr
			tmp << t.strip
			tmp << division

			# Derive Conference from Division
			tmp << (west_conf.include?(division) ? 'Western' : 'Eastern')

			if tmp.nil? || tmp.size != 4
				puts "Error: Unable to process full data for #{tname}"
			end

			# Save Team Data to global @teamList[]
			tl << tmp
			# There may be additional listings which are not for NBA teams.
			# Stop processing data when TeamID == Utah Jazz (UTA).
			if abbr == 'UTA'
				break
			end
		end
	end
end
