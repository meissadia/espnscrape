# Sets VERSION of EspnScrape
module Version
  # GEM version
  VERSION = '0.1.0'
  # Changes for 0.1.0
  # @note
  # => + Major API changes
  # => + Added README.rdoc
  # => + Integrated ActiveRecord Wrapper methods into EspnScrape class
  # => - Removed seperate ActiveRecord Wrapper module
  # => + Changed GEM license to GNU GPLv3
  CHANGES = true
end


########################### Version History ####################################
# Changes for 0.0.8
# => - NbaPlayer: Fix bug in extracting bio->college info

# 0.0.7
# => - Fix but in EspnScrape.getPlayer

# 0.0.6
# => + NbaPlayer: Get basic bio info from ESPN Player page
# => - NbaTeamSchedule: Postponed games are no longer included in Schedule listing

# 0.0.5
# => Team Schedule: Fixed bug preventing calls to EspnScrape.getSchedule
# => Test Suite: testEspnScrape has a bunch of commented out tests. Those are now active.

# 0.0.4
# => GEM description update

# 0.0.3
# => + NbaBoxScore has been rewritten for 2016 version of ESPN site.
# => + Boxscores now include PlayerID since the site only shows First Initial and Last Name (i.e. D. Wade)

# 0.0.2
# => + Cleaned up documentation

# 0.0.1
# @note
# => + Wrapper: ActiveRecord (lib/war/)
#    +   Added Module WAR to create dictionaries from espnscrape arrays
#    e   require 'war'
#    e   include WAR
#    +   TODO: Needs Testsuite
# =>   NbaBoxScore (getHomeTeamPlayers, getAwayTeamPlayers)
#    o   Corrected handling of names with apostrophes
#    +   getLastGame()
# =>   NbaSchedule
#    +   Combined Game Date/Game Time -> YYYY-MM-DD HH:MM:00
#    +     field: game_datetime
# => + module Version (lib/version/)
#    +   New version styling
#
# @fixed-bugs

# 0.0.0 Create espnscrape GEM
# @known-bugs
#   1. NbaSchedule :: Game Date, Game Time
#   => not correctly set (should be combined)
#   => not correctly set (Game Date blank)
#   => not correctly set (Game Time missing Game Date)
#   2. Roster
#   => Should be split: Player + Roster
