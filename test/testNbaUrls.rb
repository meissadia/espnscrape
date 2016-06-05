require 'minitest/autorun'
require 'open-uri'

class TestNbaUrls < Minitest::Test
	include NbaUrls
	def test_get_tid
		# Test all special cases
		tnames = ['Oklahoma City Thunder', 'Portland Trail Blazers', 'Brooklyn Nets', 'Utah Jazz', 'Jambo']
		expected = ['OKC','POR','BKN', 'UTA', 'JAM']
			result = []
			tnames.each do |x|
				result << getTid(x)
			end
			# Validate TeamIDs were correctly derived
			assert_equal expected, result
	end

	def test_format_team_url
		teams = [["uta",'utah'],["nop",'no'],["sas",'sa'],["was",'wsh'],["pho",'phx'],["gsw",'gs'],["nyk",'ny']]
		url = "%s"
		teams.each { |team_id, expected|
			assert_equal expected, formatTeamUrl(team_id, url)
		}
	end
end
