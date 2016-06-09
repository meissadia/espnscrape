### Change Log :: EspnScrape
## 0.4.0 - June 8, 2016
####&nbsp;&nbsp;&nbsp;New
+ Simplified conversion to Hashes and Structs! See [README] for details.
+ Instance versions of data access methods. Allows shorter calls i.e. es.boxscore instead of EspnScrape.boxscore
+ Cleaned out uninformative data fields ( see [! Removed !](#removed) )

####&nbsp;&nbsp;&nbsp;Changed
+ Everything is now Strings (Mostly affects NbaPlayer, NbaSchedule)
+ EspnScrape.teamList now simply returns an array of team data (no need for additional .teamList)
- NbaBoxScore: :starter field is now 'true'/'false' instead of 'X'/''

####&nbsp;&nbsp;&nbsp;! Removed !
- EspnScrape class methods **.to_hash**, **.to_hashes**, **.to_structs**. See [README] for replacements.
- EspnScrape class constants **FS_BOXSCORE**, **FS_BOXSCORE_TOTALS**, **FS_ROSTER**, **FS_TEAM**, **FS_SCHEDULE_PAST**, **FS_SCHEDULE_FUTURE**. See [SymbolDefaults] for replacements.
+ Deleted **:game_num** &nbsp;&nbsp;&nbsp;&nbsp;field from&nbsp;NbaBoxScore data.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Reason: always '0'.
+ Deleted **:win**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;field from NbaSchedule#futureGames.&nbsp;&nbsp;&nbsp;&nbsp;Reason: always 'false'.
+ Deleted **:boxscore_id**&nbsp;&nbsp;&nbsp;field from NbaSchedule#futureGames.&nbsp;&nbsp;&nbsp;&nbsp;Reason: always '0'.
+ Deleted **:game_time**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;field from&nbsp;NbaSchedule#pastGames.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Reason: always '00:00:00'.
+ Deleted **:tv**&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;field from&nbsp;NbaSchedule#pastGames.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Reason: always 'false'.

[README]:./README.md
[SymbolDefaults]: http://www.rubydoc.info/gems/espnscrape/0.4.0/SymbolDefaults

## 0.3.0 - June 7, 2016
+ Now requires Ruby >= 1.9.3
+ API Changes for NbaSchedule
+ Corrected README examples
+ Large scale code refactoring
+ Tons of code style improvements

## 0.2.0 - June 4, 2016
####&nbsp;&nbsp;&nbsp;New
+ API Changes
+ Added CHANGELOG.md
+ Travis CI integration (.travis.yml, Gemfile)
+ EspnScrape::FS_BOXSCORE_TOTALS - for hash/struct conversion of NbaBoxScore Team Totals

####&nbsp;&nbsp;&nbsp;Removed
+ NbaBoxScore#toString
+ NbaSchedule#toString
+ NbaTeamList#toString
+ Module: Util - debug utils now included in necessary Classes
+ Module: Version

####&nbsp;&nbsp;&nbsp;Changed
+ Improved Documentation
  * Clarified language
  * More links for easier navigation
  * Added examples where needed, updated others to match current usage
+ Updated gemspec to include: README, LICENSE, CHANGELOG, Rakefile, .yardopts
+ Updated gemspec to utilize EspnScrape::VERSION
+ Updated test cases

## 0.1.3
+ Updated documentation  

## 0.1.2
+ Fixed NbaPlayer.age bug
+ Add .yardopts to display README on RubyDocs

## 0.1.1
+ Added Preseason and Playoff access
+ Added Season Type to schedule rows
+ Converted README to Markdown

## 0.1.0
+ Major API changes
+ Added README.rdoc
+ Integrated ActiveRecord Wrapper methods into EspnScrape class
- Removed seperate ActiveRecord Wrapper module
+ Changed GEM license to GNU GPLv3

## 0.0.8
- NbaPlayer: Fix bug in extracting bio->college info

## 0.0.7
- Fix but in EspnScrape.getPlayer

## 0.0.6
+ NbaPlayer: Get basic bio info from ESPN Player page
- NbaTeamSchedule: Postponed games are no longer included in Schedule listing

## 0.0.5
+ Team Schedule: Fixed bug preventing calls to EspnScrape.getSchedule
+ Test Suite: testEspnScrape has a bunch of commented out tests. Those are now active.

## 0.0.4
+ GEM description update

## 0.0.3
+ NbaBoxScore has been rewritten for 2016 version of ESPN site.
+ Boxscores now include PlayerID since the site only shows First Initial and Last Name (i.e. D. Wade)

## 0.0.2
+ Cleaned up documentation

## 0.0.1
+ Wrapper: ActiveRecord (lib/war/)
+   Added Module WAR to create dictionaries from espnscrape arrays  
  * require 'war'  
  * include WAR   
+ Needs Testsuite
+ NbaBoxScore (getHomeTeamPlayers, getAwayTeamPlayers)  
  * Corrected handling of names with apostrophes  
  * lastGame()  
+ NbaSchedule  
  * Combined Game Date/Game Time -> YYYY-MM-DD HH:MM:00    
  * field: game_datetime  
+ module Version (lib/version/)  
  * New version styling

## 0.0.0
- Create espnscrape GEM
###known-bugs
* NbaSchedule :: Game Date, Game Time  
  * not correctly set (should be combined)  
  * not correctly set (Game Date blank)  
  * not correctly set (Game Time missing Game Date)  
* Roster  
  * Should be split: Player + Roster  
