require_relative '../lib/espnscrape/DebugUtils'
require 'espnscrape'
include DebugUtils

puts "EspnScrape::Version #{EspnScrape::VERSION}"

bs = EspnScrape.boxscore(400828991)
stats = bs.homePlayers # Returns multidimensional array of Home Player stats
puts asTable(stats, 10, 'Home Players:')

# Convert String array to Hash array
symbols     = EspnScrape::FS_BOXSCORE
stat_hashes = EspnScrape.to_hashes(symbols, stats) # Returns array of Hashes
puts stat_hashes.first[:p_name] # Player Name
puts stat_hashes.first[:pts]    # Player Points

# Convert String array to Struct array
stat_structs = EspnScrape.to_structs(symbols, stats) # Returns array of Structs
puts stat_structs.first.p_name # Player Name
puts stat_structs.first.pts    # Player Points

#### Access a Roster
roster = EspnScrape.roster('UTA').players # Returns multidimensional array of Roster info
puts asTable(roster, 15, 'Utah Roster:')

# Roster as an array of objects
symbols   = EspnScrape::FS_ROSTER
r_structs = EspnScrape.to_structs(symbols, roster) # Returns array of Hashes
puts r_structs.first.p_name # Player Name
puts r_structs.first.pos    # Player Position
puts r_structs.first.salary # Player Salary

#### Access a Schedule
schedule = EspnScrape.schedule('UTA') # Gets schedule for latest available season type (Pre/Regular/Post)
past     = schedule.pastGames         # multidimensional array of completed games
future   = schedule.futureGames       # multidimensional array of upcoming games
puts asTable(past, 15, 'Past Games:')
puts asTable(future, 15, 'Future Games:')

puts schedule.nextTeamId                   # String ID of next opponent

preseason = EspnScrape.schedule('BOS', 1)  # Get Preseason schedule
playoffs  = EspnScrape.schedule('CLE', 3)  # Get Playoff schedule

# Past Schedule Games as Objects
symbols = EspnScrape::FS_SCHEDULE_PAST
p_structs = EspnScrape.to_structs(symbols, past) # Returns array of Hashes
puts p_structs.first.gdate      # Game Date
puts p_structs.first.t_abbr     # Team Abbreviation
puts p_structs.first.team_score # Team Point Total
puts p_structs.first.opp_score  # Opponent Point Total

#### Access a Player
player = EspnScrape.player(2991473) # Returns an NbaPlayer object
puts player.name   #=> "Anthony Bennett"
puts player.weight #=> "245"

#### Access the NBA Team List
team_list = EspnScrape.teamList.teamList # multidimensional array of Team info
puts asTable(team_list, 25, 'NBA Teams:')

symbols   = EspnScrape::FS_TEAM
t_structs = EspnScrape.to_structs(symbols, team_list) # Hash array
puts t_structs.first.t_name   #=> 'Boston Celtics'
puts t_structs.first.t_abbr   #=> 'BOS'
puts t_structs.first.division #=> 'Atlantic'
