require 'minitest/autorun'
require_relative '../lib/espnscrape'

class TestNbaSchedule < Minitest::Test
  include NbaUrls
  def test_initialize
    numGames = 82
    schedule = NbaSchedule.new('UTA', 'test/testNbaScheduleData.html') # Data 11/21/15

    # Test getAllGames
    assert_equal numGames, schedule.getAllGames.size, "NbaSchedule: Wrong Season Length"

    # Test getNextGame
    expectedNextGame = 12
    assert_equal expectedNextGame, schedule.getNextGameId

    expectedNextGameData = ["UTA", 13, false, 0, "Nov 23", true, "OKC", "9:00 PM ET", false, "2015-11-23 21:00:00"]
    assert_equal expectedNextGameData, schedule.getNextGame

    # Test getLastGame
    expectedLastGameData = ["UTA", 12, "00:00:00", false, "Nov 20", false, "DAL", false, "93", "102", "400828071", "6", "6", "2015-11-20 00:00:00"]
    assert_equal expectedLastGameData, schedule.getLastGame

    # Test getFutureGames
    expectedFutureCount = 70
    assert_equal expectedFutureCount, schedule.getFutureGames.size

    # Test getPastGames
    expectedPastCount = 12
    assert_equal expectedPastCount, schedule.getPastGames.size

    # Test getNextTeam
    assert_equal 'OKC', schedule.getNextTeamId
  end
end
