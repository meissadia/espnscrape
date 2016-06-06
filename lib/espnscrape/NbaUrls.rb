# Methods and Urls to access ESPN NBA data
module NbaUrls
	# @return [String] URL to access Boxscore
	def boxScoreUrl
		return 'http://scores.espn.go.com/nba/boxscore?gameId='
	end

	# @return [String] URL to access NBA Team List
	def teamListUrl
		return 'http://espn.go.com/nba/teams'
	end

	# @param seasontype [INT] 1-Pre 2-Regular 3-Playoff
	# @return [String] URL to access Team Schedule
	def teamScheduleUrl(seasontype='')
		return "http://espn.go.com/nba/team/schedule/_/name/%s/seasontype/#{seasontype}"
	end

	# @return [String] URL to access Team Roster
	def teamRosterUrl
		return 'http://espn.go.com/nba/team/roster/_/name/%s/'
	end

	# @return [String] URL to access Player profile
	def playerUrl
		return 'http://espn.go.com/nba/player/_/id/'
	end

	# Generate team specific URL
	# @param team_id [String] Team ID
	# @param url [String] URL String
	# @return [String] Formatted URL
	# @example
	# 	NbaUrls.formatTeamUrl('uta', NbaUrls.teamRosterUrl) #=> "http://espn.go.com/nba/team/roster/_/name/utah/"
	def formatTeamUrl(team_id, url)
		team_id = team_id.downcase
		special = {
			'was' => 'wsh',	'nop' => 'no', 'sas' => 'sa', 'uta' => 'utah',
			'pho' => 'phx', 'gsw' => 'gs', 'nyk' => 'ny'
		}
		team_id = special[team_id] if special.keys.include?(team_id)
		return url % [team_id]
	end

	# Derive three letter Team ID from Team Name
	# @param team_name [String] Full Team Name
	# @return [String] Team ID
	# @example
	# 	getTid("Oklahoma City Thunder") #=> "OKC"
	#
	def getTid(team_name)
		result = ''
		words = team_name.split
		words.size > 2 ? words.each { |word| result << word[0] } : result = words[0][0,3]
		return checkSpecial(result)
	end

	# Adjust Outlier Abbreviations
	def checkSpecial(abbr)
		abbr.upcase!
		special = { 'OCT' => 'OKC', 'PTB' => 'POR', 'BRO' => 'BKN' }
		special.keys.include?(abbr) ? special[abbr] : abbr
	end
end
