require 'minitest/autorun'
require 'open-uri'

class TestNbaUrls < Minitest::Test
	include NbaUrls
	def test_get_tid
    expected = ['OKC','POR','BKN', 'UTA', 'JAM']
		# Test all special cases
		tnames = ['Oklahoma City Thunder', 'Portland Trail Blazers',
              'Brooklyn Nets', 'Utah Jazz', 'Jambo']
    result = []
    tnames.each do |x|
      result << getTid(x)
    end
		# Validate TeamIDs were correctly derived
    assert_equal expected, result
	end

  def test_format_team_url
		# TODO Test all TeamID adjustments
    tids = ['uta','nop','sas','was','pho','gsw','nyk']

		assert_equal "http://espn.go.com/nba/team/roster/_/name/utah/",
								 formatTeamUrl('uta', teamRosterUrl)
		assert_equal "http://espn.go.com/nba/team/roster/_/name/ny/",
								 formatTeamUrl('nyk', teamRosterUrl)

		# TODO Production Only : Test HTTP connection
		# # Open each generated URL to check for validity
    # tids.each do |t|
    #    res << open(formatTeamUrl(t, "Team Name", teamRosterUrl))
    # end
		#
    # # Validate all test cases processed
    # assert_equal res.length, tids.length
    # # Validate all pages are accessible
    # assert_equal !res.include?(false), true
  end
end
