require_relative './test_helper'

class TestEspnScrape < Minitest::Test
  def test_integration
    es = EspnScrape.new

    bs    = es.boxscore(400828991)
    stats = bs.homePlayers # Returns multidimensional array of Home Player stats

    # Convert String array to Hash array
    stat_hashes = stats.to_hashes # Returns array of Hashes
    assert_equal 'D. Favors', stat_hashes.first[:p_name], 'Boxscore.Name'
    assert_equal '14',        stat_hashes.first[:pts],    'Boxscore.Points'

    # Convert String array to Struct array
    symbols      = BOX_P
    stat_structs = stats.to_structs(symbols) # Returns array of Structs
    assert_equal 'D. Favors', stat_structs.first[:p_name], 'Boxscore.Name'
    assert_equal '14',        stat_structs.first[:pts],    'Boxscore.Points'

    #### Access a Roster
    roster = es.roster('UTA').players # Returns multidimensional array of Roster info

    # Roster as an array of objects
    r_structs = roster.to_structs # Returns array of Hashes
    assert_equal 'Trevor Booker', r_structs.first.p_name, 'Roster.name'
    assert_equal 'PF',            r_structs.first.pos,    'Roster.position'
    assert_equal '4775000',       r_structs.first.salary, 'Roster.salary'

    #### Access a Schedule
    schedule = es.schedule('UTA')         # Gets schedule for latest available season type (Pre/Regular/Post)
    past     = schedule.pastGames         # multidimensional array of completed games
    schedule.futureGames                  # multidimensional array of upcoming games

    assert_equal nil, schedule.nextTeamId, 'Schedule.Next Team'

    es.schedule('BOS', 1)                 # Get Preseason schedule
    es.schedule('CLE', 3)                 # Get Playoff schedule

    # Past Schedule Games as Objects
    p_structs = past.to_structs # Returns array of Hashes
    assert_equal 'Oct 28', p_structs.first.gdate,      'schedule.Game Date'
    assert_equal 'UTA',    p_structs.first.t_abbr,     'schedule.Team Abbreviation'
    assert_equal '87',     p_structs.first.team_score, 'schedule.Team Point Total'
    assert_equal '92',     p_structs.first.opp_score,  'schedule.Opponent Point Total'

    #### Access a Player
    player = es.player(2991473) # Returns an NbaPlayer object
    assert_equal 'Anthony Bennett', player.name,    'Player.name'
    assert_equal '245',             player.weight,  'Player.weight'

    #### Access the NBA Team List
    team_list = es.teamList # multidimensional array of Team info

    t_structs = team_list.to_structs # Hash array
    assert_equal 'Boston Celtics', t_structs.first.t_name,    'Team.name'
    assert_equal 'BOS',            t_structs.first.t_abbr,    'Team.abbr'
    assert_equal 'Atlantic',       t_structs.first.division,  'Team.div'

    #### Customize field names
    ROSTER.change_sym!(:p_name, :full_name).change_sym!(:salary, :crazy_money)
    players = EspnScrape.roster('CLE').players.to_structs
    assert_equal 'LeBron James', players[3].full_name,   ':full_name => LeBron James'
    assert_equal '22970500',     players[3].crazy_money, ':crazy_money => 22970500'

    TEAM_L.replace [:short, :long, :div, :conf]
    t = EspnScrape.teamList.to_structs
    assert_equal 'BOS', t.first.short, '# => BOS'
  end
end
