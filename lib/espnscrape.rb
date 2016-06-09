# gems
require 'nokogiri'

# libraries
require 'open-uri'
require 'time'

#To Hash | Struct conversions
require_relative 'espnscrape/ArrayConversions'

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
  VERSION = '0.4.0'.freeze

  # Returns an {NbaBoxScore} object
  # @param game_id [Integer] Boxscore ID
  # @return [NbaBoxScore] NbaBoxScore
  # @example
  #   EspnScrape.boxscore(493848273)
  def self.boxscore(game_id)
    NbaBoxScore.new game_id
  end

  # Returns an {NbaBoxScore} object
  # @param (see .boxscore)
  # @return (see .boxscore)
  # @example
  #  es.boxscore(493848273)
  def boxscore(game_id)
    EspnScrape.boxscore game_id
  end

  # Returns an {NbaRoster} object
  # @param team_id [String] Team ID
  # @return [NbaRoster] NbaRoster
  # @example
  #   EspnScrape.roster('UTA')
  def self.roster(team_id)
    NbaRoster.new team_id
  end

  # Returns an {NbaRoster} object
  # @param (see .roster)
  # @return (see .roster)
  # @example
  #  es.roster('UTA')
  def roster(team_id)
    EspnScrape.roster team_id
  end

  # Return Array of Team Data
  # @return [[[String]]] NBA Team Data
  # @example
  #  EspnScrape.teamList
  def self.teamList
    NbaTeamList.new.teamList
  end

  # Return Array of Team Data
  # @return (see .teamList)
  # @example
  #  es.teamList
  def teamList
    EspnScrape.teamList
  end

  # Return an {NbaSchedule} object
  # @param team_id [String] Team ID
  # @param s_type [Int] Season Type
  # @return [NbaSchedule] NbaSchedule
  # @example
  #   EspnScrape.schedule('UTA')    # Schedule for Latest Season Type
  #   EspnScrape.schedule('TOR', 3) # Playoff Schedule
  def self.schedule(team_id, s_type = '')
    NbaSchedule.new team_id, '', s_type
  end

  # Return an {NbaSchedule} object
  # @param (see .schedule)
  # @return (see .schedule)
  # @example
  #  es.schedule('MIA')     # Schedule for Latest Season Type
  #  es.schedule('DET', 1)  # Preseason Schedule
  def schedule(team_id, s_type = '')
    EspnScrape.schedule team_id, s_type
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
