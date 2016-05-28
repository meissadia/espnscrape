require 'minitest/autorun'
require_relative '../lib/espnscrape'

class TestEspnScrape < Minitest::Test

  def test_get_boxscore
    game_id = 400828035
    bs = EspnScrape.boxscore(game_id)
    assert_equal false, bs.nil?, "ES.boxscore.Set"
    assert_equal "Cleveland Cavaliers", bs.homeName, "ES.boxscore.homeTeam"
  end

  def test_get_roster
    r = EspnScrape.roster('UTA')
    assert_equal false, r.nil?, "ES.roster.Set"
  end

  def test_get_team_list
    tl = EspnScrape.teamList
    assert_equal false, tl.nil?, "Lazy instantiation of NbaTeamList"
    assert_equal tl.teamList.size, 30, "Team Count => Incorrect"
  end

  def test_get_schedule
    r = EspnScrape.schedule('UTA')
    assert_equal false, r.nil?, "ES.Schedule.Set"
  end

end
