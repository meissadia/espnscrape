# Field Symbol Defaults for Array Type Conversion
module SymbolDefaults
  # @note Field Symbols for {NbaBoxScore#homePlayers} and {NbaBoxScore#awayPlayers}
  #   [Team ID, ESPN Player ID, Player Name (short),  Position, Minutes, Field Goals Made, Field Goals Attempted, 3P Made, 3P Attempted, Free Throws Made, Free Throws Attempted, Offensive Rebounds, Defensive Rebounds, Total Rebounds, Assists, Steals, Blocks, Turnovers, Personal Fouls, Plus/Minus, Points, Starter?]
  BOX_P = [:t_abbr, :p_eid, :p_name, :pos, :min, :fgm, :fga, :tpm, :tpa, :ftm, :fta, :oreb, :dreb, :reb, :ast, :stl, :blk, :tos, :pf, :plus, :pts, :starter]

  # @note Field Symbols for {NbaBoxScore#homeTotals} and {NbaBoxScore#awayTotals}
  #   [Team ID, Field Goals Made, Field Goals Attempted, 3P Made, 3P Attempted, Free Throws Made, Free Throws Attempted, Offensive Rebounds, Defensive Rebounds, Total Rebounds, Assists, Steals, Blocks, Turnovers, Personal Fouls, Plus/Minus, Points, Starter?]
  BOX_T = [:t_abbr, :fgm, :fga, :tpm, :tpa, :ftm, :fta, :oreb, :dreb, :reb, :ast, :stl, :blk, :tos, :pf, :pts]

  # @note Field Symbols for {NbaSchedule#futureGames}
  #   [Team ID, Game #, Game Date, Home Game?, Opponent ID, Game Time, Televised?, Game DateTime, Season Type]
  GAME_F = [:t_abbr, :game_num, :gdate, :home, :opp_abbr, :gtime, :tv, :g_datetime, :season_type]

  # @note Field Symbols for {NbaSchedule#pastGames}
  #   [Team ID, Game #, Game Date, Home Game?, Opponent ID, Win?, Team Score, Opp Score, Boxscore ID, Wins, Losses, Game DateTime, Season Type]
  GAME_P = [:t_abbr, :game_num, :gdate, :home, :opp_abbr, :win, :team_score, :opp_score, :boxscore_id, :wins, :losses, :g_datetime, :season_type]

  # @note Field Symbols for {NbaRoster#players}
  #  [Team ID, Jersey #, Player Name, ESPN Player ID, Position, Age, Height ft, Height in, Weight, College, Salary]
  ROSTER = [:t_abbr, :p_num, :p_name, :p_eid, :pos, :age, :h_ft, :h_in, :weight, :college, :salary]

  # @note Field Symbols for {NbaTeamList#teamList}
  #  [Team ID, Team Name, Division, Conference]
  TEAM_L = [:t_abbr, :t_name, :division, :conference]
end
