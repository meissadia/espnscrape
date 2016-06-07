require_relative './test_helper'

class TestNbaSchedule < Minitest::Test
  include NbaUrls
  include DebugUtils

  # Test Regular Season
  def test_file_regular
    schedule = NbaSchedule.new('', 'test/data/scheduleData.html', 2) # Data 11/21/15

    # Test allGames
    assert_equal 82, schedule.allGames.size, 'NbaSchedule: Wrong Season Length'

    # Test nextGame
    expected = 12
    assert_equal expected, schedule.nextGameId

    expected = ['UTA', 13, false, 0, 'Nov 23', true, 'OKC', '9:00 PM ET', false, '2015-11-23 21:00:00', 2]
    assert_equal expected, schedule.nextGame

    # Test lastGame
    expected = ['UTA', 12, '00:00:00', false, 'Nov 20', false, 'DAL', false, '93', '102', '400828071', '6', '6', '2015-11-20 00:00:00', 2]
    assert_equal expected, schedule.lastGame

    # Test futureGames
    expected = 70
    assert_equal expected, schedule.futureGames.size

    # Test pastGames
    expected = 12
    assert_equal expected, schedule.pastGames.size

    asTable(schedule.pastGames, 15, 'UTA Past', true)

    # Test getNextTeam
    expected = 'OKC'
    assert_equal expected, schedule.nextTeamId
  end

  # Test Preseason
  def test_file_preseason
    schedule = NbaSchedule.new('GSW', 'test/data/schedulePreseasonData.html', 1)
    assert_equal 7, schedule.allGames.size
    assert_equal 7, schedule.pastGames.size
    assert_equal 0, schedule.futureGames.size

    # Test Schedule with Non-NBA Teams
    schedule = NbaSchedule.new('BOS', 'test/data/scheduleInternationalData.html')
    assert_equal 7, schedule.allGames.size
    assert_equal 7, schedule.pastGames.size
    assert_equal 0, schedule.futureGames.size
  end

  # Test Playoffs
  def test_file_playoff
    schedule = NbaSchedule.new('GSW', 'test/data/schedulePlayoffData.html', 3)
    assert_equal 'CLE', schedule.nextTeamId
    assert_equal 7,     schedule.futureGames.size
    assert_equal 24,    schedule.allGames.size
    assert_equal 3,     schedule.nextGame.last
  end
end
