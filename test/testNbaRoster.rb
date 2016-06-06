require 'minitest/autorun'
require_relative '../lib/espnscrape'

class TestNbaRoster < Minitest::Test
  include NbaUrls
  include DebugUtils

  def test_live_data
    team_id = 'UTA'
    roster = NbaRoster.new(team_id)

    #test Coach
    assert_equal "Quin Snyder", roster.coach, "Verify Coach => #{roster.coach}"

    #test Players
    assert_equal 11,   roster.players[0].size,    "Roster Columns => Fail\n#{roster.players[0]}"
    assert_equal true, roster.players.size >= 12, "Roster Player Count => Fail"
  end

  def test_file_data
    roster = NbaRoster.new '', 'test/rosterData.html'
    booker = ["UTA", "33", "Trevor Booker", "4270", "PF", "28", "6", "8", "228", "Clemson", "4775000"]

    assert_equal booker,         roster.players[0],    "Trevor Booker => Fail"
    assert_equal "Quin Snyder",  roster.coach,         "Verify Coach => #{roster.coach}"
    assert_equal 15,             roster.players.size,  "Roster Player Count => Fail"

  end
end
