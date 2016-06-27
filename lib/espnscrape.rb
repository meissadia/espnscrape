# gems
require 'nokogiri'

# libraries
require 'open-uri'
require 'time'

# Core Extensions
require_relative 'espnscrape/Hash'
require_relative 'espnscrape/Struct'
require_relative 'espnscrape/String'

# To Hash | Struct conversions
require_relative 'espnscrape/ArrayConversions'

require_relative 'espnscrape/Navigator'

# espnscrape
require_relative 'espnscrape/NbaUrls'
require_relative 'espnscrape/NbaBoxScore'
require_relative 'espnscrape/NbaRoster'
require_relative 'espnscrape/NbaTeamList'
require_relative 'espnscrape/NbaSchedule'
require_relative 'espnscrape/NbaPlayer'

# Modules
require_relative 'espnscrape/SymbolDefaults'
require_relative 'espnscrape/PrintUtils'
include SymbolDefaults
include PrintUtils

# EspnScrape main class
class EspnScrape
  # Gem Version
  VERSION = '0.5.1'.freeze
  # initialize
  def initialize(config = {})
    @format = defaultFormat(config[:format])
  end

  # Returns an {NbaBoxScore} object
  # @param game_id [Integer] Boxscore ID
  # @return [NbaBoxScore] NbaBoxScore
  # @example
  #   EspnScrape.boxscore(493848273)
  def self.boxscore(game_id, f_mat = nil)
    NbaBoxScore.new(game_id: game_id,
                    format: defaultFormat(f_mat))
  end

  # Returns an {NbaBoxScore} object
  # @param (see .boxscore)
  # @return (see .boxscore)
  # @example
  #  es.boxscore(493848273)
  def boxscore(game_id, f_mat = nil)
    EspnScrape.boxscore game_id, (f_mat || @format)
  end

  # Returns an {NbaRoster} object
  # @param team_id [String] Team ID
  # @return [NbaRoster] NbaRoster
  # @example
  #   EspnScrape.roster('UTA')
  def self.roster(team_id, f_mat = nil)
    NbaRoster.new(team_id: team_id,
                  format: defaultFormat(f_mat))
  end

  # Returns an {NbaRoster} object
  # @param (see .roster)
  # @return (see .roster)
  # @example
  #  es.roster('UTA')
  def roster(team_id, f_mat = nil)
    EspnScrape.roster team_id, (f_mat || @format)
  end

  # Return Array of Team Data
  # @return [[[String]]] NBA Team Data
  # @example
  #  EspnScrape.teamList
  def self.teamList(f_mat = nil)
    NbaTeamList.new(format: defaultFormat(f_mat)).teamList
  end

  # Return Array of Team Data
  # @return (see .teamList)
  # @example
  #  es.teamList
  def teamList(f_mat = nil)
    EspnScrape.teamList(f_mat || @format)
  end

  # Return an {NbaSchedule} object
  # @param team_id [String] Team ID
  # @param s_type [Int] Season Type
  # @return [NbaSchedule] NbaSchedule
  # @example
  #   EspnScrape.schedule('UTA')    # Schedule for Latest Season Type
  #   EspnScrape.schedule('TOR', 3) # Playoff Schedule
  def self.schedule(team_id, s_type = '', f_mat = nil)
    NbaSchedule.new(team_id: team_id,
                    season_type: s_type,
                    format: defaultFormat(f_mat))
  end

  # Return an {NbaSchedule} object
  # @param (see .schedule)
  # @return (see .schedule)
  # @example
  #  es.schedule('MIA')     # Schedule for Latest Season Type
  #  es.schedule('DET', 1)  # Preseason Schedule
  def schedule(team_id, s_type = '', f_mat = nil)
    EspnScrape.schedule team_id, s_type, (f_mat || @format)
  end

  # Return new {NbaPlayer} object
  # @param espn_id [String] ESPN Player ID
  # @return [NbaPlayer] NbaPlayer
  # @example
  #   EspnScrape.player(2991473)
  def self.player(espn_id)
    NbaPlayer.new espn_id
  end

  # Return new {NbaPlayer} object
  # @param (see .player)
  # @return (see .player)
  # @example
  #  es.player(2991473)
  def player(espn_id)
    EspnScrape.player espn_id
  end
end
