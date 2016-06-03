# Methods and Urls to access ESPN NBA data
module NbaUrls
	# @return [String] URL
	def boxScoreUrl
		return 'http://scores.espn.go.com/nba/boxscore?gameId='
	end
	# @return (see #boxScoreUrl)
	def teamListUrl
		return 'http://espn.go.com/nba/teams'
	end
	# teamScheduleUrl
	# @param seasontype [INT] 1-Pre 2-Regular 3-Playoff
	# @return (see #boxScoreUrl)
	def teamScheduleUrl(seasontype=2)
		return "http://espn.go.com/nba/team/schedule/_/name/%s/seasontype/#{seasontype}"
	end
	# teamRosterUrl
	# @return (see #boxScoreUrl)
	def teamRosterUrl
		return 'http://espn.go.com/nba/team/roster/_/name/%s/'
	end
	# playerUrl
	# @return (see #boxScoreUrl)
	def playerUrl
		return 'http://espn.go.com/nba/player/_/id/'
	end

	# Generate team specific URL
	# @param team_id [String] Three letter representation of Team
	# @param url [String] String with url data location
	# @return [String] Resulting URL
	# @example
	# 	NbaUrls.formatTeamUrl('uta', NbaUrls.teamRosterUrl) #=> "http://espn.go.com/nba/team/roster/_/name/utah/"
	#
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

	# Derive three letter TeamID from Team Name
	# @param team_name [String] City Team Name
	# @return [String] TeamID
	# @example
	# 	getTid("Oklahoma City Thunder") #=> "OKC"
	#
	def getTid(team_name)
		abbr_tmp = team_name.split
		abbr = ""
		if abbr_tmp.size > 2
			abbr_tmp.each do |x|
				abbr << x[0]
			end
			abbr.upcase!
		else
			abbr = abbr_tmp[0][0..2].upcase
		end

		case abbr
		when 'OCT'
			abbr = 'OKC'
		when 'PTB'
			abbr = 'POR'
		when 'BRO'
			abbr = 'BKN'
		end

		return abbr
	end
end
