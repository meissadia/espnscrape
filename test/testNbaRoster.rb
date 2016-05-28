require 'minitest/autorun'
require_relative '../lib/espnscrape'

class TestNbaRoster < Minitest::Test
  include NbaUrls

	def test_initialize
    team_id = 'UTA'
    roster = NbaRoster.new(team_id)

    #test Coach
    assert_equal "Quin Snyder", roster.coach, "Verify Coach => Fail"

    #test Players
    assert_equal 11, roster.players[0].size, "Roster Columns => Fail"
    assert_equal true, roster.players.size >= 12, "Roster Player Count => Fail"

  end
end
