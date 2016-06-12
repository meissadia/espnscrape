
# EspnScrape v0.5.0
[![Gem Version](https://badge.fury.io/rb/espnscrape.svg)](https://badge.fury.io/rb/espnscrape)
[![Code Climate](https://codeclimate.com/github/meissadia/espnscrape/badges/gpa.svg)](https://codeclimate.com/github/meissadia/espnscrape)
[![Build Status](https://travis-ci.org/meissadia/espnscrape.svg?branch=master)](https://travis-ci.org/meissadia/espnscrape)
[![Test Coverage](https://codeclimate.com/github/meissadia/espnscrape/badges/coverage.svg)](https://codeclimate.com/github/meissadia/espnscrape/coverage)

## Table of Contents
+ [Table of Contents](#table-of-contents)
+ [Introduction](#introduction)
+ [Installation](#installation)
  + [Rails](#rails)
  + [Manual](#manual)
+ [Arrays, Hashes or Structs](#arrays-hashes-or-structs)
  + [Working With Multiple Formats](#working-with-multiple-formats)
    + [Default format](#default-format)
    + [Same data using Hashes](#same-data-using-hashes)
    + [Same data using Structs](#same-data-using-structs)
  + [Customize Field Names in Hash or Struct Conversion](#customize-field-names-in-hash-or-struct-conversion)
    + [Overwrite](#overwrite)
    + [Use As Template](#use-as-template)
+ [Working with Navigators](#working-with-navigators)
  + [Navigator Methods](#navigator-methods)
+ [Data Access](#data-access)
  + [NBA Team List](#nba-team-list)
  + [Boxscore](#boxscore)
    + [Player Data](#player-data)
    + [Team Data](#team-data)
  + [Roster](#roster)
  + [Player](#player)
  + [Schedule](#schedule)
    + [Past Schedule Games as Objects](#past-schedule-games-as-objects)
    + [Future Schedule Games as Objects](#future-schedule-games-as-objects)
    + [Select a specific Season Type](#select-a-specific-season-type)
+ [Documentation](#documentation)
+ [Requirements](#requirements)
  + [Ruby version](#ruby-version)
  + [Dependencies](#dependencies)
+ [Testing](#testing)

## Introduction
The EspnScrape Ruby GEM is a data scraper for the redesigned 2016 version of ESPN.com.
It provides a number of ways to simplify data collection and interaction such as :  
* Structs - Intuitively access data via dot notation.  
* Hashes - Can be passed directly to ActiveRecord CRUD methods for easy database interaction.  
* String arrays - Raw data for you to manipulate as you see fit.

```
This GEM is subject to frequent, sometimes non-backwards compatible changes.
Until a major (1.0.0) release, minor versions (0.4.0) indicate potentially incompatible changes.
Utility and usability are the goal, so I hope the API evolution helps more than hurts.
```

Check the [CHANGELOG] for more info || **`Currently only for NBA`** || *EspnScrape is not associated with ESPN or the NBA.*

## Installation
+ ### Rails
In your application's Gemfile, include :  
```
gem 'espnscrape'
```

  In your project dir, execute :  
```
> bundle install
```

+ ### Manual
```
> gem install espnscrape
```

## Arrays, Hashes or Structs
If you intend to work with a single format, you can specify it at initialization. When working with multiple formats you should start with the default, String Arrays [[String]], and convert as necessary using [Array#to_structs] or [Array#to_hashes].

    require 'espnscrape'
    es   = EspnScrape.new                              # String Arrays
    es_h = EspnScrape.new({ :format => :to_hashes })   # Hash Arrays
    es_s = EspnScrape.new({ :format => :to_structs })  # Struct Arrays


### Working With Multiple Formats
You can easily convert Arrays to Hashes or Structs  

+ #### Default format
```ruby
es    = EspnScrape.new
bs    = es.boxscore(400828991)   # Return an NbaBoxscore object
stats = bs.homePlayers           # Returns a multidimensional array of Home Player stats
stats[4][2]                      # Player Name   # => 'R. Hood'
stats[4][20]                     # Player Points # => '30'
```

+ #### Same data using Hashes
```ruby
s_hashes = stats.to_hashes       # Returns array of Hashes
s_hashes[4][:name]               # Player Name   # => 'R. Hood'
s_hashes[4][:points]             # Player Points # => '30'
```

+ #### Same data using Structs
```ruby
s_structs = stats.to_structs     # Returns array of Structs
s_structs[4].name                # Player Name   # => 'R. Hood'
s_structs[4].points              # Player Points # => '30'
```

### Customize Field Names in Hash or Struct Conversion
The [Array#to_hashes] and [Array#to_structs] methods can be passed an array of Symbols
to use in place of the default field names.
```ruby
team_list   = EspnScrape.teamList
team_list_s = t.to_structs [:abbrev, :long_team_name, :div, :conf]
team_list_s.last.long_team_name    # => 'Utah Jazz'
```

Defaults are defined in the [SymbolDefaults] module.
You can overwrite them or use them as templates, replacing individual symbols using
the [Array#change_sym!] method.

+ #### Overwrite  

  ```ruby
  S_TEAM    # => [:team,  :name, :division, :conference]
  S_TEAM.replace [:short, :long, :div, :conf]
  t = EspnScrape.teamList.to_structs

  t.first.short # => 'BOS'
  t.first.long  # => 'Boston Celtics'
  ```

+ #### Use As Template
  ```ruby
  my_names = S_ROSTER.dup.change_sym!(:p_name, :full_name).change_sym!(:salary, :crazy_money)
  players  = EspnScrape.roster('CLE').players.to_structs
  players[3].full_name    # => 'LeBron James'
  players[3].crazy_money  # => '22970500'
  ```


## Working with Navigators
Table data is wrapped in a [Navigator] class which provides helper methods for moving through the table. The type of object the Navigator returns matches the format provided at EspnScrape instantiation.  Data converted using [#to_structs] or [#to_hashes] is not wrapped in a Navigator.

  + ### Navigator Methods
  ```ruby
  # <Navigator> A Navigator for Home Player Stats Table
  navigator = EspnScrape.boxscore(400878158).homePlayers

  navigator[]      # Array<Object> Returns the underlying Array of the Navigator
  navigator[5]     # <Object> 6th row of data
  navigator.size   # <Fixnum> Number of table rows
  navigator.first  # <Object> Access the first data row
  navigator.last   # <Object> Access the last data row
  navigator.next   # <Object> Access the next data row     (nil if there is no more data)
  navigator.curr   # <Object> Access the current data row  (nil at initialization)
  navigator.prev   # <Object> Access the previous data row (nil if there is no more data)
  ```

## Data Access

  + ### NBA Team List
  ```ruby
  es        = EspnScrape.new
  team_list = es.teamList      # multidimensional array of Team info
  team_list.last               # => ['UTA', 'Utah Jazz', 'Northwest', 'Western']
  team_list.last[0]            # => 'UTA'
  team_list.last[1]            # => 'Utah Jazz'
  team_list.last[2]            # => 'Northwest'
  team_list.last[3]            # => 'Western'
  ```

  + ### Boxscore
  ```ruby
  es    = EspnScrape.new({ :format => :to_structs })
  bs    = es.boxscore(400875892)   # Return an NbaBoxscore object

  bs.id                 # <String> Boxscore ID    # => '400875892'
  bs.gameDate           # <String> Game DateTime  # => '2016-05-07 00:00:00'

  bs.homeName           # <String> Full Team Name
  bs.homeScore          # <Struct> Team Score
  bs.homeTotals         # <Struct> Access the cumulative team totals
  bs.homePlayers        # <Navigator> A Navigator for Home Player Stats Table

  bs.awayName           # <String> Full Team Name
  bs.awayScore          # <Struct> Team Score
  bs.awayTotals         # <Struct> Access the cumulative team totals
  bs.awayPlayers        # <Navigator> A Navigator for Home Player Stats Table

  ```

      * #### Player Data  
      ```ruby
      wade = bs.homePlayers[4] # <Struct> of data for Row 5

      wade.first.team       # <String> Team ID          # => 'MIA'
      wade.first.id         # <String> Player ID        # => '1987'
      wade.first.name       # <String> Short Name       # => 'D. Wade'
      wade.first.position   # <String> Position         # => 'SG'
      wade.first.minutes    # <String> Minutes          # => '36'
      wade.first.fgm        # <String> Shots Made       # => '13'
      wade.first.fga        # <String> Shots Attempted  # => '25'
      wade.first.tpm        # <String> 3P Made          # => '4'
      wade.first.tpa        # <String> 3P Attempted     # => '6'
      wade.first.ftm        # <String> Freethrows Made  # => '8'
      wade.first.fta        # <String> Freethrows Att.  # => '8'
      wade.first.oreb       # <String> Offensive Reb.   # => '1'
      wade.first.dreb       # <String> Defensive Reb.   # => '7'
      wade.first.rebounds   # <String> Total Rebounds   # => '8'
      wade.first.assists    # <String> Assists          # => '4'
      wade.first.steals     # <String> Steals           # => '0'
      wade.first.blocks     # <String> Blocks           # => '0'
      wade.first.tos        # <String> Turnovers        # => '4'
      wade.first.fouls      # <String> Personal Fouls   # => '1'
      wade.first.plusminus  # <String> Plus/Minus       # => '-8'
      wade.first.points     # <String> Points           # => '38'
      wade.first.starter    # <String> Starter?         # => 'true'
      ```

      + #### Team Data  
      ```ruby
      miami = bs.homeTotals   # <Struct> Access the team totals
      miami.team
      miami.fgm
      miami.fga
      miami.tpm
      miami.tpa
      miami.ftm
      miami.fta
      miami.oreb
      miami.dreb
      miami.rebounds
      miami.assists
      miami.steals
      miami.blocks
      miami.turnovers
      miami.fouls
      miami.points

      ```

  + ### Roster
  Roster#players is a <[Navigator]>.
  ```ruby
  roster  = es.roster('UTA')        
  players = roster.players         # Returns multidimensional array of Roster info
  coach   = roster.coach           # Coach Name # => 'Quinn Snyder'

  # Roster as an array of objects
  r_structs = players.to_structs   # Returns array of Structs

  r_structs[2].team                # Team ID          # => 'UTA'
  r_structs[2].jersey              # Jersey Number    # => '11'
  r_structs[2].name                # Name             # => 'Alec Burks'
  r_structs[2].id                  # ID               # => '6429'
  r_structs[2].position            # Position         # => 'SG'
  r_structs[2].age                 # Age              # => '24'
  r_structs[2].height_ft           # Height (ft)      # => '6'
  r_structs[2].height_in           # Height (in)      # => '6'
  r_structs[2].salary              # Salary           # => '9463484'
  r_structs[2].weight              # Weight           # => '214'
  r_structs[2].college             # College          # => 'Colorado'
  r_structs[2].salary              # Salary           # => '9463484'
  ```

  + ### Player
  ```ruby
  player = es.player(2991473) # Returns an NbaPlayer object
  player.name                 #=> "Anthony Bennett"
  player.age                  #=> "23"
  player.weight               #=> "245"
  player.college              #=> "UNLV"
  player.height_ft            #=> "6"
  player.height_in            #=> "8"
  ```

  + ### Schedule
  Schedule#allGames, #pastGames, #futureGames return <[Navigator]>

  ```ruby
  schedule = es.schedule('UTA')     # Gets schedule for latest available season type (Pre/Regular/Post)
  schedule.nextGame                 # <Object> Next unplayed game info
  schedule.lastGame                 # <Object> Previously completed game info
  schedule.nextTeamId               # <String> Team ID of next opponent # => 'OKC'
  schedule.nextGameId               # <Fixnum> Index of next unplayed game

  past     = schedule.pastGames     # Completed Games : multidimensional array
  future   = schedule.futureGames   # Upcoming Games  : multidimensional array
  ```

    + #### Past Schedule Games as Structs

    ```ruby
    p_s = past.to_structs    # Returns array of Structs
    p_s.team                 # Team ID
    p_s.game_num             # Game # in Season
    p_s.date                 # Game Date
    p_s.home                 # Home?
    p_s.opponent             # Opponent ID
    p_s.win                  # Win?
    p_s.team_score           # Team Score
    p_s.opp_score            # Opponent Score
    p_s.boxscore_id          # Boxscore ID
    p_s.wins                 # Team Win Count
    p_s.losses               # Team Loss Count
    p_s.datetime             # Game DateTime
    p_s.season_type          # Season Type
    ```

    + #### Future Schedule Games as Structs

    ```ruby
    f_s = future.to_structs  # Returns array of Structs
    f_s.team                 # Team ID
    f_s.game_num             # Game # in Season
    f_s.date                 # Game Date
    f_s.home                 # Home?
    f_s.opponent             # Opponent ID
    f_s.time                 # Game Time
    f_s.win                  # Win?
    f_s.tv                   # Game on TV?
    f_s.opp_score            # Opponent Score
    f_s.datetime             # Game DateTime
    f_s.season_type          # Season Type
    ```

    + #### Select a specific Season Type
    
    ```ruby
    preseason = es.schedule('BOS', 1)   # Get Preseason schedule
    regular   = es.schedule('NYK', 2)   # Get Regular schedule
    playoffs  = es.schedule('OKC', 3)   # Get Playoff schedule
    ```

## Chaining it all together
```ruby
# Get a Boxscore from a past game
EspnScrape.schedule('OKC', 2).allGames[42].boxscore(:to_structs).awayPlayers.first.name

# Get a Roster from a Team ID
EspnScrape.boxscore(400827977).homeTotals[0].roster(:to_hashes).players.first[:name]

'cle'.roster.players.next.position

# Get a Schedule from a Team ID
EspnScrape.teamList.last[0].schedule(:to_hashes).lastGame.boxscore

'gsw'.schedule(:to_structs).lastGame.boxscore

```

## Documentation
Available on [RubyDoc.info] or locally:  
```
> yard doc  
> yard server
```

## Requirements
+ ### Ruby version
*Ruby >= 1.9.3*  

+ ### Dependencies
*Nokogiri 1.6*  
*Rake ~> 10.4.2*  
*minitest ~> 5.4*

## Testing
    > rake

[SymbolDefaults]: ./lib/espnscrape/SymbolDefaults.rb
[RubyDoc.info]: http://www.rubydoc.info/gems/espnscrape/0.4.0
[CHANGELOG]: ./CHANGELOG.md
[Array#to_hashes]: http://www.rubydoc.info/gems/espnscrape/0.5.0/Array#to_hashes-instance_method
[#to_hashes]: http://www.rubydoc.info/gems/espnscrape/0.5.0/Array#to_hashes-instance_method
[Array#to_structs]: http://www.rubydoc.info/gems/espnscrape/0.5.0/Array#to_structs-instance_method
[#to_structs]: http://www.rubydoc.info/gems/espnscrape/0.5.0/Array#to_structs-instance_method
[Array#change_sym!]: http://www.rubydoc.info/gems/espnscrape/0.5.0/Array#change_sym%21-instance_method
[Navigator]: http://www.rubydoc.info/gems/espnscrape/0.5.0/Navigator
