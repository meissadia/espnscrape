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
		case team_id
		when 'uta'
			team_id = 'utah'
		when 'nop'
			team_id = 'no'
		when 'sas'
			team_id = 'sa'
		when 'was'
			team_id = 'wsh'
		when 'pho'
			team_id = 'phx'
		when 'gsw'
			team_id = 'gs'
		when 'nyk'
			team_id = 'ny'
		end
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
		name_words = team_name.split
		if name_words.size > 2
			name_words.each do |word|
				result << word[0]
			end
			result.upcase!
		else
			result = name_words[0][0..2].upcase
		end
		return checkSpecial(result)
	end

	# Adjust Outlier Abbreviations
	def checkSpecial(abbr)
		case abbr
		when 'OCT'
			return 'OKC'
		when 'PTB'
			return 'POR'
		when 'BRO'
			return 'BKN'
		end
		return abbr
	end
end
