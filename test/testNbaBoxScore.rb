require 'minitest/autorun'
require_relative '../lib/espnscrape'

class TestNbaBoxScore < Minitest::Test
  include NbaUrls
  attr_reader :game_id

  # Test Game ID
  @@game_id_past = 400828035
  # @@game_id_future = 400876754 # Game date: 2016-05-26 19:00:00

	def test_initialize
    # => Test Game: Past
    bs = NbaBoxScore.new(@@game_id_past)
    assert_equal false, bs.nil?, "Unable to Initialize object"
    assert_equal "2015-11-15 00:00:00", bs.gameDate, "Game Date => Incorrect"

    # Validate Team Names
    t = [bs.awayName, bs.homeName].sort
    assert_equal ["Atlanta Hawks", "Utah Jazz"], t, "Team Names => Incorrect"

    # Validate Away Team Stats
    assert_equal ["UTA", "0", "4257", "D. Favors", "PF", "32", "11", "20", "0", "1", "1", "1", "4", "5", "9", "3", "0", "2", "4", "2", "+1", "23", "X"],
      bs.awayPlayers[0], "Away Stats => Mismatch"
    # Team Totals
    assert_equal 18, bs.awayTotals.size, "Away Totals => Wrong # columns"

    # Validate Home Team Stats
    assert_equal ["ATL", "0", "3015", "P. Millsap", "PF", "37", "10", "18", "1", "4", "7", "8", "1", "5", "6", "2", "1", "2", "3", "2", "+6", "28", "X"],
      bs.homePlayers[0], "Home Stats => Mismatch"
    # Team Totals
    assert_equal 18, bs.homeTotals.size, "Home Totals => Wrong # columns"

    # # => Test Game: Future
    # bs = NbaBoxScore.new(@@game_id_future)
    # assert_equal false, bs.nil?, "Unable to Initialize object"
    # assert_equal "2016-05-26 19:00:00", bs.getGameDate, "Game Date => Incorrect"
    #
    # # Validate Team Names
    # t = [bs.getawayName(), bs.gethomeName()].sort
    # assert_equal ["Golden State Warriors", "Oklahoma City Thunder"], t, "Team Names => Incorrect"

  end
end
