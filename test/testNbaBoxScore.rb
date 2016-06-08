require_relative './test_helper'

class TestNbaBoxScore < Minitest::Test
  include NbaUrls
  attr_reader :game_id

  # => Test Game: Past
  def test_live_past
    bs = NbaBoxScore.new(400828035)
    assert_equal false, bs.nil?, 'Unable to Initialize object'
    assert_equal '2015-11-15 00:00:00', bs.gameDate, 'Game Date => Incorrect'

    # Validate Team Names
    t = ['Atlanta Hawks', 'Utah Jazz']
    assert_equal t, [bs.awayName, bs.homeName].sort, 'Team Names => Incorrect'

    # Validate Away Team Stats
    assert_equal ['UTA', '0', '4257', 'D. Favors', 'PF', '32', '11', '20', '0', '1', '1', '1', '4', '5', '9', '3', '0', '2', '4', '2', '+1', '23', 'X'], bs.awayPlayers[0], 'Away Stats => Mismatch'
    # Team Totals
    assert_equal 16, bs.awayTotals.size, "Away Totals => Wrong # columns\n#{bs.awayTotals.inspect}"

    # Validate Home Team Stats
    assert_equal ['ATL', '0', '3015', 'P. Millsap', 'PF', '37', '10', '18', '1', '4', '7', '8', '1', '5', '6', '2', '1', '2', '3', '2', '+6', '28', 'X'], bs.homePlayers[0], 'Home Stats => Mismatch'
    # Team Totals
    assert_equal 16, bs.homeTotals.size, 'Home Totals => Wrong # columns'
  end

  # =>  Boxscore with Non-NBA Team
  def test_live_non_nba_opponent
    bs = NbaBoxScore.new 400832210
    assert_equal 'Milan Olimpia', bs.homeName
    assert_equal '2015-10-06 00:00:00', bs.gameDate, 'Game Date -> Incorrect'
  end
end
