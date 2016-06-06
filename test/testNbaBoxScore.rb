require 'minitest/autorun'
require_relative '../lib/espnscrape'

class TestNbaBoxScore < Minitest::Test
  include NbaUrls
  attr_reader :game_id

  # Test Game ID
  @@game_id_past = 400828035

  def test_live_data
    # => Test Game: Past
    bs = NbaBoxScore.new(@@game_id_past)
    assert_equal false, bs.nil?, "Unable to Initialize object"
    assert_equal "2015-11-15 00:00:00", bs.gameDate, "Game Date => Incorrect"

    # Validate Team Names
    t = ["Atlanta Hawks", "Utah Jazz"]
    assert_equal t, [bs.awayName, bs.homeName].sort, "Team Names => Incorrect"

    # Validate Away Team Stats
    assert_equal ["UTA", "0", "4257", "D. Favors", "PF", "32", "11", "20", "0", "1", "1", "1", "4", "5", "9", "3", "0", "2", "4", "2", "+1", "23", "X"], bs.awayPlayers[0], "Away Stats => Mismatch"
    # Team Totals
    assert_equal 16, bs.awayTotals.size, "Away Totals => Wrong # columns\n#{bs.awayTotals.inspect}"

    # Validate Home Team Stats
    assert_equal ["ATL", "0", "3015", "P. Millsap", "PF", "37", "10", "18", "1", "4", "7", "8", "1", "5", "6", "2", "1", "2", "3", "2", "+6", "28", "X"], bs.homePlayers[0], "Home Stats => Mismatch"
    # Team Totals
    assert_equal 16, bs.homeTotals.size, "Home Totals => Wrong # columns"

    # Boxscore with Non-NBA Team
    bs = NbaBoxScore.new 400832210
    assert_equal 'Milan Olimpia', bs.homeName
    assert_equal '2015-10-06 00:00:00', bs.gameDate, "Game Date -> Incorrect"
  end

  def test_file_data
    # # => Test Game: Future
    # bs = NbaBoxScore.new('', 'test/boxscoreFuture.html')
    # assert_equal false, bs.nil?, "Unable to Initialize object"
    # assert_equal "2016-06-08 19:00:00", bs.getGameDate, "Game Date => Incorrect"
    #
    # # Validate Team Names
    # t = ["Cleveland Cavaliers", "Golden State Warriors"]
    # assert_equal t, [bs.getawayName, bs.gethomeName].sort, "Team Names => Incorrect"
  end
end
