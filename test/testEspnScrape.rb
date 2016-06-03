require 'minitest/autorun'
require_relative '../lib/espnscrape'

class TestEspnScrape < Minitest::Test

  def test_get_boxscore
    game_id = 400828035
    bs = EspnScrape.boxscore(game_id)
    assert_equal "Utah Jazz", bs.awayName, "ES.boxscore.homeTeam"
  end

  def test_get_roster
    r = EspnScrape.roster('UTA')
    assert_equal false, r.nil?, "ES.roster.Set"
  end

  def test_get_team_list
    tl = EspnScrape.teamList
    assert_equal tl.teamList.size, 30, "Team Count => Incorrect"
  end

  def test_get_schedule
    r = EspnScrape.schedule('UTA')
    assert_equal false, r.nil?, "ES.Schedule.Set"
  end

  def test_hashes
    tl = EspnScrape.teamList.teamList
    fl_a = EspnScrape.to_hashes(EspnScrape::FS_TEAM, tl)
    assert_equal "BOS", fl_a[0][:t_abbr], "to_hashes fail"
  end

  def test_structs
    tl = EspnScrape.teamList.teamList
    fl_a = EspnScrape.to_structs(EspnScrape::FS_TEAM, tl)
    assert_equal "BOS", fl_a[0].t_abbr, "to_structs fail"
  end

end
