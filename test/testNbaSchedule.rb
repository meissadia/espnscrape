require_relative './test_helper'

class TestNbaSchedule < Minitest::Test
  include NbaUrls
  include DebugUtils

  # Test Regular Season
  def test_file_regular
    numGames = 82
    schedule = NbaSchedule.new('', 'test/data/scheduleData.html') # Data 11/21/15

    # Test getAllGames
    assert_equal numGames, schedule.getAllGames.size, "NbaSchedule: Wrong Season Length"

    # Test getNextGame
    expected = 12
    assert_equal expected, schedule.getNextGameId

    expected = ["UTA", 13, false, 0, "Nov 23", true, "OKC", "9:00 PM ET", false, "2015-11-23 21:00:00", 2]
    assert_equal expected, schedule.getNextGame

    # Test getLastGame
    expected = ["UTA", 12, "00:00:00", false, "Nov 20", false, "DAL", false, "93", "102", "400828071", "6", "6", "2015-11-20 00:00:00", 2]
    assert_equal expected, schedule.getLastGame

    # Test getFutureGames
    expected = 70
    assert_equal expected, schedule.getFutureGames.size

    # Test getPastGames
    expected = 12
    assert_equal expected, schedule.getPastGames.size

    # Test getNextTeam
    expected = 'OKC'
    assert_equal expected, schedule.getNextTeamId
  end

  # Test Preseason
  def test_file_preseason
    schedule = NbaSchedule.new('GSW', 'test/data/schedulePreseasonData.html')
    assert_equal 7, schedule.getAllGames.size
    assert_equal 7, schedule.getPastGames.size
    assert_equal 0, schedule.getFutureGames.size

    # Test Schedule with Non-NBA Teams
    schedule = NbaSchedule.new('BOS', 'test/data/scheduleInternationalData.html')
    assert_equal 7, schedule.getAllGames.size
    assert_equal 7, schedule.getPastGames.size
    assert_equal 0, schedule.getFutureGames.size
  end

  # Test Playoffs
  def test_file_playoff
    schedule = NbaSchedule.new('GSW', 'test/data/schedulePlayoffData.html')
    assert_equal 'CLE', schedule.getNextTeamId
    assert_equal 7,     schedule.getFutureGames.size
    assert_equal 24,    schedule.getAllGames.size
    assert_equal 3,     schedule.getNextGame.last
  end
end
