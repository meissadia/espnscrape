require_relative './test_helper'

class TestEspnScrape < Minitest::Test

  def test_get_boxscore
    bs = EspnScrape.boxscore(400828035)
    assert_equal "Utah Jazz", bs.awayName, "Boxscore Error"
  end

  def test_get_roster
    r = EspnScrape.roster('UTA')
    assert_equal false, r.nil?, "Roster Error"
  end

  def test_get_team_list
    tl = EspnScrape.teamList
    assert_equal 30, tl.teamList.size,  "Team List Error"
  end

  def test_get_schedule
    s = EspnScrape.schedule('UTA')
    assert_equal true, s.getAllGames.count > 0, "Schedule Error"
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
