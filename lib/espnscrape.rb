# gems
require 'nokogiri'

# libraries
require 'open-uri'
require 'time'

# espnscrape
require_relative 'espnscrape/NbaUrls'
require_relative 'espnscrape/NbaBoxScore'
require_relative 'espnscrape/NbaRoster'
require_relative 'espnscrape/NbaTeamList'
require_relative 'espnscrape/NbaSchedule'
require_relative 'espnscrape/NbaPlayer'

# debug utilities
require_relative 'espnscrape/DebugUtils'

# EspnScrape main class
class EspnScrape
  # Gem Version
  VERSION = '0.3.0'.freeze

  # @note Field Symbols for {NbaBoxScore}
  #   [Team ID, Game #, Player Name (short), ESPN Player ID, Position, Minutes, Field Goals Made, Field Goals Attempted, 3P Made, 3P Attempted, Free Throws Made, Free Throws Attempted, Offensive Rebounds, Defensive Rebounds, Total Rebounds, Assists, Steals, Blocks, Turnovers, Personal Fouls, Plus/Minus, Points, Starter?]
  FS_BOXSCORE = [:t_abbr, :game_num, :p_eid, :p_name, :pos, :min, :fgm, :fga, :tpm, :tpa, :ftm, :fta, :oreb, :dreb, :reb, :ast, :stl, :blk, :tos, :pf, :plus, :pts, :starter].freeze

  # @note Field Symbols for {NbaBoxScore#homeTotals} and {NbaBoxScore#awayTotals}
  #   [Team ID, Field Goals Made, Field Goals Attempted, 3P Made, 3P Attempted, Free Throws Made, Free Throws Attempted, Offensive Rebounds, Defensive Rebounds, Total Rebounds, Assists, Steals, Blocks, Turnovers, Personal Fouls, Plus/Minus, Points, Starter?]
  FS_BOXSCORE_TOTALS = [:t_abbr, :fgm, :fga, :tpm, :tpa, :ftm, :fta, :oreb, :dreb, :reb, :ast, :stl, :blk, :tos, :pf, :pts].freeze

  # @note Field Symbols for {NbaRoster}
  #  [Team ID, Jersey #, Player Name, ESPN Player ID, Position, Age, Height ft, Height in, Weight, College, Salary]
  FS_ROSTER = [:t_abbr, :p_num, :p_name, :p_eid, :pos, :age, :h_ft, :h_in, :weight, :college, :salary].freeze

  # @note Field Symbols for {NbaSchedule#pastGames}
  #   [Team ID, Game #, Game Time, Televised?, Game Date, Home Game?, Opponent ID, Win?, Team Score, Opp Score, Boxscore ID, Wins, Losses, Game DateTime, Season Type]
  FS_SCHEDULE_PAST = [:t_abbr, :game_num, :gtime, :tv, :gdate, :home, :opp_abbr, :win, :team_score, :opp_score, :boxscore_id, :wins, :losses, :g_datetime, :season_type].freeze

  # @note Field Symbols for {NbaSchedule#futureGames}
  #   [Team ID, Game #, Win?, Boxscore ID, Game Date, Home Game?, Opponent ID, Game Time, Televised?, Game DateTime, Season Type]
  FS_SCHEDULE_FUTURE = [:t_abbr, :game_num, :win, :boxscore_id, :gdate, :home, :opp_abbr, :gtime, :tv, :g_datetime, :season_type].freeze

  # @note Field Symbols for {NbaTeamList#teamList}
  #  [Team ID, Team Name, Division, Conference]
  FS_TEAM = [:t_abbr, :t_name, :division, :conference].freeze

  # Returns an {NbaBoxScore} object
  # @param game_id [Integer] Boxscore ID
  # @return [NbaBoxScore] NbaBoxScore
  # @example
  #   EspnScrape.boxscore(493848273)
  def self.boxscore(game_id)
    NbaBoxScore.new game_id
  end

  # Returns an {NbaRoster} object
  # @param team_id [String] Team ID
  # @return [NbaRoster] NbaRoster
  # @example
  #   EspnScrape.roster('UTA')
  def self.roster(team_id)
    NbaRoster.new team_id
  end

  # Return {NbaTeamList}
  # @return [NbaTeamList] NbaTeamList
  # @example
  #  EspnScrape.teamList
  def self.teamList
    NbaTeamList.new
  end

  # Return an {NbaSchedule} object
  # @param team_id [String] Team ID
  # @param s_type [Int] Season Type
  # @return [NbaSchedule] NbaSchedule
  # @example
  #   EspnScrape.schedule('UTA')    # Schedule for Latest Season Type
  #   EspnScrape.schedule('BOS', 1) # Preseason Schedule
  #   EspnScrape.schedule('MIA', 2) # Regular Season Schedule
  #   EspnScrape.schedule('TOR', 3) # Playoff Schedule
  def self.schedule(team_id, s_type = '')
    NbaSchedule.new team_id, '', s_type
  end

  # Return new {NbaPlayer} object
  # @param espn_id [String] ESPN Player ID
  # @return [NbaPlayer] NbaPlayer
  # @example
  #   EspnScrape.player(2991473)
  def self.player(espn_id)
    NbaPlayer.new espn_id
  end

  # Create Hash from array
  # @param field_names [Array] Symbols to be used as field names
  # @param source [Array] Source data
  # @return [Hash] Hash
  # @example
  #   symbols  = EspnScrape::FS_TEAM
  #   team_row = EspnScrape.teamList.teamList.first
  #   hash     = EspnScrape.to_hash(symbols, team_row)
  #   => {:t_abbr=>"BOS", :t_name=>"Boston Celtics", :division=>"Atlantic", :conference=>"Eastern"}
  def self.to_hash(field_names, source)
    fl = {} # Resulting Field List

    # Create key(from source):value(from field names) pairs
    field_names.each_with_index do |f, idx|
      fl[f] = source[idx]
    end
    fl
  end

  # Create Hash Array
  # @param field_names [Array] Symbols to be used as field names
  # @param source [[Array]] Source data
  # @return [[Hash]] Array<Hash>
  # @example
  #   symbols = EspnScrape::FS_TEAM
  #   teams   = EspnScrape.teamList.teamList
  #   hash_a  = EspnScrape.to_hashes(symbols, teams)
  #   => [{:t_abbr=>"BOS", :t_name=>"Boston Celtics", :division=>"Atlantic", :conference=>"Eastern"},
  #       {:t_abbr=>"BKN", :t_name=>"Brooklyn Nets", :division=>"Atlantic", :conference=>"Eastern"} ... ]
  def self.to_hashes(field_names, source)
    fl_a = []             # Resulting Hash Array
    source.each do |s|    # Process each row of Source table
      fl_a << to_hash(field_names, s)
    end
    fl_a
  end

  # Create Struct Array
  # @param field_names [Array] Symbols to be used as field names
  # @param source [[Array]] Source data
  # @return [[Struct]] Array<Struct>
  # @example
  #   symbols = EspnScrape::FS_TEAM
  #   teams   = EspnScrape.teamList.teamList
  #   structs = EspnScrape.to_structs(symbols, teams)
  #   => [#<struct t_abbr="BOS", t_name="Boston Celtics", division="Atlantic", conference="Eastern">,
  #       #<struct t_abbr="BKN", t_name="Brooklyn Nets", division="Atlantic", conference="Eastern"> ... ]
  def self.to_structs(field_names, source)
    fl_a = []             # Resulting Hash Array
    source.each do |s|    # Process each row of Source table
      hash = to_hash(field_names, s)
      fl_a << Struct.new(*hash.keys).new(*hash.values)
    end
    fl_a
  end
end
