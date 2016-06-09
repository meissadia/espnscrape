
## EspnScrape v0.4.0
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

```
This GEM is subject to frequent, sometimes non-backwards compatible changes.
Until a major (1.0.0) release, minor versions (0.4.0) indicate potentially incompatible changes.
Utility and usability are the goal, so I hope the API evolution helps more than hurts.
```

Check the [CHANGELOG] for more info || **`Currently only for NBA`** || *EspnScrape is not associated with ESPN or the NBA.*

## Quick Start
### Installation
##### Rails
In your application's Gemfile, include :  
```
gem 'espnscrape'
```

In your project dir, execute :  
```
> bundle install
```

##### Manual
```
> gem install espnscrape
```

### Examples
    require 'espnscrape'
    es = EspnScrape.new

#### Access a Boxscore
```ruby
bs    = es.boxscore(400828991)
stats = bs.homePlayers        # Returns multidimensional array of Home Player stats
stats.first[2]                # First Player Name   # => D. Favors   
stats[0][20]                  # First Player Points # => 14

# Same data using Hashes
s_hashes = stats.to_hashes    # Returns array of Hashes
s_hashes.first[:p_name]       # Player Name
s_hashes.first[:pts]          # Player Points

# Same data using Structs
s_structs = stats.to_structs  # Returns array of Structs
s_structs.first.p_name        # Player Name
s_structs.first.pts           # Player Points
```

#### Access a Roster
```ruby
roster  = es.roster('UTA')        
players = roster.players         # Returns multidimensional array of Roster info
coach   = roster.coach           # Coach Name # => 'Quinn Snyder'

# Roster as an array of objects
r_structs = players.to_structs   # Returns array of Structs

r_structs[2].p_name              # Player Name      # => 'Alec Burks'
r_structs[2].pos                 # Player Position  # => 'SG'
r_structs[2].salary              # Player Salary    # => '9463484'
```

#### Access a Schedule
```ruby
schedule = es.schedule('UTA')       # Gets schedule for latest available season type (Pre/Regular/Post)
past     = schedule.pastGames       # Completed Games : multidimensional array
future   = schedule.futureGames     # Upcoming Games  : multidimensional array
schedule.nextTeamId                 # String ID of next opponent # => 'OKC'

# Past Schedule Games as Objects
p_structs = past.to_structs         # Returns array of Hashes

p_structs.first.gdate               # Game Date
p_structs.first.t_abbr              # Team Abbreviation
p_structs.first.team_score          # Team Point Total
p_structs.first.opp_score           # Opponent Point Total

# Select a specific Season Type
preseason = es.schedule('BOS', 1)   # Get Preseason schedule
playoffs  = es.schedule('OKC', 3)   # Get Playoff schedule

```

#### Access a Player
```ruby
player = es.player(2991473) # Returns an NbaPlayer object
player.name                 #=> "Anthony Bennett"
player.weight               #=> "245"
```

#### Access the NBA Team List
```ruby
team_list = es.teamList          # multidimensional array of Team info
team_list.last                   # => ['UTA', 'Utah Jazz', 'Northwest', 'Western']

t_structs = team_list.to_structs # Struct array
t_structs.first.t_name           #=> 'Boston Celtics'
t_structs.first.t_abbr           #=> 'BOS'
t_structs.first.division         #=> 'Atlantic'
```

#### Customize field names in Hash or Struct conversion
The [Array#to_hashes] and [Array#to_structs] methods can be passed an array of Symbols
to use in place of the default field names.
```ruby
t = EspnScrape.teamList
t_s = t.to_structs %w(short long div conf).map{ |x| x.to_sym }
puts t_s.first.short
```

Defaults are defined in the [SymbolDefaults] module.
You can overwrite them or use them as templates, replacing symbols with
the Array#change_sym! method defined as part of this gem.

```ruby
# Overwrite
TEAM_L.replace [:short, :long, :div, :conf]
t = EspnScrape.teamList.to_structs
t.first.short # => 'BOS'

# Use As Template
my_names = ROSTER.dup.change_sym!(:p_name, :full_name).change_sym!(:salary, :crazy_money)
players  = EspnScrape.roster('CLE').players.to_structs
players[3].full_name    # => 'LeBron James'
players[3].crazy_money  # => '22970500'
```
## Documentation
Available on [RubyDoc.info] or locally:  
```
> yard doc
> yard server
```

## Requirements
#### Ruby version
*Ruby >= 1.9.3*  

#### Dependencies
*Nokogiri 1.6*  
*Rake ~> 10.4.2*  
*minitest ~> 5.4*

## Testing
    > rake

[SymbolDefaults]: http://www.rubydoc.info/gems/espnscrape/0.4.0/SymbolDefaults
[RubyDoc.info]: http://www.rubydoc.info/gems/espnscrape/0.4.0
[CHANGELOG]: ./CHANGELOG.md
[Array#to_hashes]: http://www.rubydoc.info/gems/espnscrape/0.4.0/Array#to_hashes-instance_method
[Array#to_structs]: http://www.rubydoc.info/gems/espnscrape/0.4.0/Array#to_structs-instance_method
