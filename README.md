## EspnScrape v0.3.0
[![Gem Version](https://badge.fury.io/rb/espnscrape.svg)](https://badge.fury.io/rb/espnscrape)
[![Code Climate](https://codeclimate.com/github/meissadia/espnscrape/badges/gpa.svg)](https://codeclimate.com/github/meissadia/espnscrape)
[![Build Status](https://travis-ci.org/meissadia/espnscrape.svg?branch=master)](https://travis-ci.org/meissadia/espnscrape)
[![Test Coverage](https://codeclimate.com/github/meissadia/espnscrape/badges/coverage.svg)](https://codeclimate.com/github/meissadia/espnscrape/coverage)

## Introduction
The EspnScrape Ruby GEM is a data scraper for the redesigned 2016 version of ESPN.com.
It provides a number of ways to simplify data collection and interaction such as :  
* Structs - Intuitively access data via dot notation.  
* Hashes - Can be passed directly to ActiveRecord CRUD methods for easy database interaction.  
* String arrays - Raw data for you to manipulate as you see fit.

*This GEM is under going frequent, sometimes non-backwards compatible changes.
Until it reaches a major (1.0.0) release, minor versions indicate potentially
incompatible changes. Utility and usability are the goal, so API adjustments
will creep in when helpful.*

### Restrictions
*Currently only for NBA*

### Notes
*EspnScrape is not associated with ESPN or the NBA.*

## Quick Start
### Installation
##### Rails
In your application's Gemfile, include :  
`gem 'espnscrape'`  

Then, in your project dir, execute :  
`> bundle install`

##### Manual
`> gem install espnscrape`

### Examples
    require 'espnscrape'

#### Access a Boxscore
```ruby
bs = EspnScrape.boxscore(400828991)
stats = bs.homePlayers # Returns multidimensional array of Home Player stats

# Convert String array to Hash array
symbols     = EspnScrape::FS_BOXSCORE
stat_hashes = EspnScrape.to_hashes(symbols, stats) # Returns array of Hashes
stat_hashes.first[:p_name] # Player Name
stat_hashes.first[:pts]    # Player Points

# Convert String array to Struct array
stat_structs = EspnScrape.to_structs(symbols, stats) # Returns array of Structs
stat_structs.first.p_name # Player Name
stat_structs.first.pts    # Player Points
```

#### Access a Roster
```ruby
roster = EspnScrape.roster('UTA').players # Returns multidimensional array of Roster info

# Roster as an array of objects
symbols   = EspnScrape::FS_ROSTER
r_structs = EspnScrape.to_structs(symbols, roster) # Returns array of Hashes
r_structs.first.p_name # Player Name
r_structs.first.pos    # Player Position
r_structs.first.salary # Player Salary
```

#### Access a Schedule
```ruby
schedule = EspnScrape.schedule('UTA') # Gets schedule for latest available season type (Pre/Regular/Post)
past     = schedule.pastGames         # multidimensional array of completed games
future   = schedule.futureGames       # multidimensional array of upcoming games
schedule.nextTeamId                   # String ID of next opponent

preseason = EspnScrape.schedule('BOS', 1)  # Get Preseason schedule
playoffs  = EspnScrape.schedule('CLE', 3)  # Get Playoff schedule

# Past Schedule Games as Objects
symbols   = EspnScrape::FS_SCHEDULE_PAST
p_structs = EspnScrape.to_structs(symbols, past) # Returns array of Hashes
p_structs.first.gdate      # Game Date
p_structs.first.t_abbr     # Team Abbreviation
p_structs.first.team_score # Team Point Total
p_structs.first.opp_score  # Opponent Point Total
```

#### Access a Player
```ruby
player = EspnScrape.player(2991473) # Returns an NbaPlayer object
player.name   #=> "Anthony Bennett"
player.weight #=> "245"
```

#### Access the NBA Team List
```ruby
team_list = EspnScrape.teamList.teamList # multidimensional array of Team info

symbols   = EspnScrape::FS_TEAM
t_structs = EspnScrape.to_structs(symbols, team_list) # Hash array
t_structs.first.t_name   #=> 'Boston Celtics'
t_structs.first.t_abbr   #=> 'BOS'
t_structs.first.division #=> 'Atlantic'
```
## Documentation
Available on [RubyDoc](http://www.rubydoc.info/gems/espnscrape/0.3.0) or locally:  
```
> gem install yard
> yard doc
> yard server
```

## Requirements
#### Ruby version
*Ruby >= 1.9.2*  

#### Dependencies
*Nokogiri 1.6*  
*Rake ~> 10.4.2*  
*minitest ~> 5.4*

## Testing
    > rake
