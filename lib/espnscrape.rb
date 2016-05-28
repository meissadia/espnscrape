# gems
require 'nokogiri'

# libraries
require 'open-uri'
require 'time'

# espnscrape
require_relative 'version/version'
require_relative 'espnscrape/NbaUrls'
require_relative 'espnscrape/NbaBoxScore'
require_relative 'espnscrape/NbaRoster'
require_relative 'espnscrape/NbaTeamList'
require_relative 'espnscrape/NbaSchedule'
require_relative 'espnscrape/NbaPlayer'

# debug utilities
require_relative 'espnscrape/util'

# EspnScrape main class
class EspnScrape
  include Version
  # Field Symbols for BOXSCORE
  # [TeamId, Game #, Player Name (short), ESPN Player ID, Position, Minutes, Field Goals Made, Field Goals Attempted, 3P Made, 3P Attempted, Free Throws Made, Free Throws Attempted, Offensive Rebounds, Defensive Rebounds, Total Rebounds, Assists, Steals, Blocks, Turnovers, Personal Fouls, Plus/Minus, Points, Starter?]
  FS_BOXSCORE = [:t_abbr,:game_num,:p_eid,:p_name,:pos,:min,:fgm,:fga,:tpm,:tpa,:ftm,:fta,:oreb,:dreb,:reb,:ast,:stl,:blk,:tos,:pf,:plus,:pts,:starter]

  # Field Symbols for ROSTER
  #[TeamId, Jersey #, Player Name, ESPN Player ID, Position, Age, Height ft, Height in, Weight, College, Salary]
  FS_ROSTER = [:t_abbr,:p_num,:p_name,:p_eid,:pos,:age,:h_ft,:h_in,:weight,:college,:salary]

  # Field Symbols for Schedule PAST game
  #[TeamId, Game #, Game Time, TV?, Game Date, Home?, OppID, Win?, Team Score, Opp Score, boxscore_id, wins, losses, game_datetime]
  FS_SCHEDULE_PAST = [:t_abbr,:game_num,:gtime,:tv,:gdate,:home,:opp_abbr,:win,:team_score,:opp_score,:boxscore_id,:wins,:losses, :g_datetime]

  # Field Symbols for Schedule FUTURE game
  #[TeamId, Game #, Win?, boxscore_id, Game Date, Home?, OppID, Game Time, TV?, game_datetime]
  FS_SCHEDULE_FUTURE = [:t_abbr,:game_num,:win,:boxscore_id,:gdate,:home,:opp_abbr,:gtime, :tv, :g_datetime]

  # Field Symbols for TEAM
  #[TeamId, Team Name, Division, Conference]
  FS_TEAM = [:t_abbr,:t_name,:division,:conference]

  # Returns an NbaBoxscore object
  # @param game_id [Integer]
  # @return [NbaBoxScore]
  # @example
  #   EspnScrape.boxscore(493848273)
  def self.boxscore(game_id)
    return NbaBoxScore.new game_id
  end

  # Returns an NbaRoster object
  # @param team_id [String]
  # @return [NbaRoster]
  # @example
  #   EspnScrape.roster('UTA')
  def self.roster(team_id)
    return NbaRoster.new team_id
  end

  # Return NbaTeamList
  # @return [NbaTeamList]
  def self.teamList
    return NbaTeamList.new
  end

  # Return an NbaSchedule object
  # @param team_id [String]
  # @return [NbaSchedule]
  # @example
  #   EspnScrape.schedule('UTA')
  def self.schedule(team_id)
    return NbaSchedule.new team_id
  end

  # Return new NbaPlayer object
  # @param espn_id [String]
  # @return [NbaPlayer]
  # @example
  #   EspnScrape.player(2991473)
  def self.player(espn_id)
    return NbaPlayer.new espn_id
  end

  # Create Hash from array
  # @param field_names [Array] Symbols of fields
  # @param source [Array] Source data
  # @return [Hash] Hash
  def self.to_hash(field_names=[], source=[])
    fl = {}                # Resulting Field List
    idx = 0                # Source cursor

    # Create k:v (from source) for each key (from field names)
    field_names.each do |f|
      fl[f] = source[idx]
      idx += 1
    end
    return fl
  end

  # Create Hash Array
  # @param field_names [Array] Symbols of fields
  # @param source [[Array]] Source data
  # @return [[Hash]] Hash Array
  def self.to_hashes(field_names=[], source=[])
    fl_a = []
    # Process each row of Source table
    source.each do |s|
      fl_a << to_hash(field_names, s)
    end
    return fl_a
  end

  # Create Struct Array
  # @param field_names [Array] Symbols of fields
  # @param source [[Array]] Source data
  # @return [[Struct]] Struct Array
  def self.to_structs(field_names=[], source=[])
    fl_a = []
    # Process each row of Source table
    source.each do |s|
      hash = to_hash(field_names, s)
      fl_a << Struct.new(*hash.keys).new(*hash.values)
    end
    return fl_a
  end

end
