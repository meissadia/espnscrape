require_relative './test_helper'

class TestNbaTeamList < Minitest::Test
  include NbaUrls
  def test_live_data
    tl = NbaTeamList.new

    # Test Team Count
    assert_equal 30, tl.teamList.size, 'NbaTeamList => Wrong # Teams'

    # Validate Header value
    assert_equal 'NBA Teams', tl.header, 'NbaTeamList => Wrong :header'

    # Validate Team List contents
    team_list = [
      ['BOS', 'Boston Celtics', 'Atlantic', 'Eastern'],
      ['BKN', 'Brooklyn Nets', 'Atlantic', 'Eastern'],
      ['NYK', 'New York Knicks', 'Atlantic', 'Eastern'],
      ['PHI', 'Philadelphia 76ers', 'Atlantic', 'Eastern'],
      ['TOR', 'Toronto Raptors', 'Atlantic', 'Eastern'],
      ['GSW', 'Golden State Warriors', 'Pacific', 'Western'],
      ['LAC', 'Los Angeles Clippers', 'Pacific', 'Western'],
      ['LAL', 'Los Angeles Lakers', 'Pacific', 'Western'],
      ['PHO', 'Phoenix Suns', 'Pacific', 'Western'],
      ['SAC', 'Sacramento Kings', 'Pacific', 'Western'],
      ['CHI', 'Chicago Bulls', 'Central', 'Eastern'],
      ['CLE', 'Cleveland Cavaliers', 'Central', 'Eastern'],
      ['DET', 'Detroit Pistons', 'Central', 'Eastern'],
      ['IND', 'Indiana Pacers', 'Central', 'Eastern'],
      ['MIL', 'Milwaukee Bucks', 'Central', 'Eastern'],
      ['DAL', 'Dallas Mavericks', 'Southwest', 'Western'],
      ['HOU', 'Houston Rockets', 'Southwest', 'Western'],
      ['MEM', 'Memphis Grizzlies', 'Southwest', 'Western'],
      ['NOP', 'New Orleans Pelicans', 'Southwest', 'Western'],
      ['SAS', 'San Antonio Spurs', 'Southwest', 'Western'],
      ['ATL', 'Atlanta Hawks', 'Southeast', 'Eastern'],
      ['CHA', 'Charlotte Hornets', 'Southeast', 'Eastern'],
      ['MIA', 'Miami Heat', 'Southeast', 'Eastern'],
      ['ORL', 'Orlando Magic', 'Southeast', 'Eastern'],
      ['WAS', 'Washington Wizards', 'Southeast', 'Eastern'],
      ['DEN', 'Denver Nuggets', 'Northwest', 'Western'],
      ['MIN', 'Minnesota Timberwolves', 'Northwest', 'Western'],
      ['OKC', 'Oklahoma City Thunder', 'Northwest', 'Western'],
      ['POR', 'Portland Trail Blazers', 'Northwest', 'Western'],
      ['UTA', 'Utah Jazz', 'Northwest', 'Western']
    ]

    assert_equal team_list, tl.teamList, 'NbaTeamList => Content Fail'

    tl = NbaTeamList.new('test/data/teamList.html')
    assert_equal team_list, tl.teamList, 'NbaTeamList => File Content Fail'
  end
end
