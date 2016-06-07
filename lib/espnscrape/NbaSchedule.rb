# Access NBA team schedule data
class NbaSchedule
  include NbaUrls
  include DebugUtils

  attr_reader :game_list, :next_game

  # Read Schedule data for a given Team
  # @param tid [String] Team ID
  # @param file [String] HTML Test Data
  # @param seasontype [Integer] Season Type
  # @note
  #  Season Types: 1-Preseason; 2-Regular Season; 3-Playoffs
  # @example
  # 	test     = NbaSchedule.new('', 'test/data/testData.html')
  # 	pre      = NbaSchedule.new('UTA', '', 1)
  # 	playoffs = NbaSchedule.new('GSW', '', 3)
  def initialize(tid, file = '', seasontype = '')
    doc, seasontype = getNokoDoc(tid, file, seasontype)
    exit if doc.nil?

    @game_list = []	# Processed Schedule Data
    @next_game = 0 	# Cursor to start of Future Games

    schedule, year, indicator, tid = collectNodeSets(doc, tid)
    season_valid = verifySeasonType(seasontype, indicator)
    seasontype = findSeasonType(indicator) if seasontype.eql?(0)

    processSeason(schedule, tid, year, seasontype) if season_valid && !seasontype.eql?(0)
  end

  # @return [[[String]]] Table of All Schedule data
  # @see EspnScrape::FS_SCHEDULE_FUTURE
  # @see EspnScrape::FS_SCHEDULE_PAST
  def allGames
    @game_list
  end

  # Returns Schedule info of next game
  # @return [[String]] Future Schedule Row ({EspnScrape::FS_SCHEDULE_FUTURE Description})
  # @note (see #futureGames)
  # @example
  # 	nextGame #=> ["GSW", 19, false, 0, "Jun 5", true, "CLE", "8:00 PM ET", true, "2016-06-05 20:00:00", 3]
  def nextGame
    @game_list[@next_game] unless @game_list.nil?
  end

  # Returns Schedule info of last completed game
  # @return [[String]] Past Schedule Row ({EspnScrape::FS_SCHEDULE_PAST Description})
  # @note (see #pastGames)
  # @example
  # 	lastGame #=> ["UTA", 82, "00:00:00", false, "Apr 13", false, "LAL", false, "96", "101", "400829115", "40", "42", "2016-04-13 00:00:00", 2]
  def lastGame
    @game_list[@next_game - 1]
  end

  # @return [Integer] Game # of Next Game
  def nextGameId
    @next_game
  end

  # @return [String] Team ID of next opponent
  # @example
  #   nextTeamId #=> "OKC"
  def nextTeamId
    nextGame[6] if nextGame
  end

  # @return [[String]] Table of Future Games ({EspnScrape::FS_SCHEDULE_FUTURE Description})
  # @note (see EspnScrape::FS_SCHEDULE_FUTURE)
  def futureGames
    @game_list[@next_game, game_list.size]
  end

  # Return Schedule info of Past Games
  # @return [[String]] Table of Past Games ({EspnScrape::FS_SCHEDULE_PAST Description})
  # @note (see EspnScrape::FS_SCHEDULE_PAST)
  def pastGames
    @game_list[0, @next_game]
  end

  private

  # Return Nokogiri XML Document
  def getNokoDoc(tid, file, season_type)
    return Nokogiri::HTML(open(file)), season_type unless file.empty? # Use File

    url = formatTeamUrl(tid, teamScheduleUrl(season_type))
    [Nokogiri::HTML(open(url)), season_type] # Use Live Data
  end

  # Extract NodeSets
  def collectNodeSets(doc, tid)
    schedule = doc.xpath('//div/div/table/tr') # Schedule Rows
    year     = doc.xpath('//div[@id=\'my-teams-table\']/div/div/div/h1').text.split('-')[1].strip.to_i # Season Starting Year
    season   = doc.xpath("//tr[@class='stathead']").text.split[1].downcase # preseason/regular/postseason
    tid = getTid(doc.title.split(/\d{4}/)[0].strip) if tid.empty?
    [schedule, year, season, tid]
  end

  # Ensure requested season type is what is being processed
  def verifySeasonType(s_type, indicator)
    # If season type is provided, verify
    case s_type
    when 1, 2, 3
      return s_type.eql?(findSeasonType(indicator))
    end
    true
  end

  # Determine season type from document data
  def findSeasonType(indicator)
    # Determine season type
    return 1 if indicator.include?('pre')
    return 2 if indicator.include?('regular')
    return 3 if indicator.include?('post')
    nil
  end

  # Process Table of Schedule Data
  def processSeason(schedule, tid, year1, seasontype)
    seasontype = seasontype.to_i
    game_id = 0 # 82-game counter
    ws = ls	= 0 # Playoff Win/Loss Counters

    # Process Schedule lines
    schedule.each do |row|
      game_date = ''
      game_time = ''
      if ('a'..'z').cover?(row.text[1]) # => Non-Header Row
        tmp = [tid, game_id += 1] # TeamID, GameID

        if row.children.size == 3                  # => Postponed Game
          game_id -= 1
          next
        elsif row.children[2].text.include?(':')   # => Future Game
          game_date, game_time = futureGame(row, tmp)
        else # => Past Game
          @next_game = game_id
          game_time = '00:00:00'	# Game Time (Not shown for past games)
          tmp << game_time << false # Game Time, TV
          game_date, ws, ls = pastGame(row, tmp, ws, ls, seasontype)
        end
      end
      saveProcessedScheduleRow(tmp, game_date, year1, game_time, seasontype)
    end
  end

  # Process Past Game Row
  def pastGame(row, result, ws, ls, season_type)
    row.children[0, 4].each_with_index do |cell, cnt|
      txt = cell.text.chomp
      if cnt == 0	# Game Date
        result << txt.split(',')[1].strip
      elsif cnt == 1 			 									# Home Game? and Opponent ID
        saveHomeOpponent(cell, result, txt)
      elsif cnt == 2 			 									# Game Result
        saveGameResult(cell, result, txt)
      else # Team Record
        saveTeamRecord(result, season_type, ws, ls, txt)
      end
    end
    # 		 Game Date, wins, losses
    [result[4], ws, ls]
  end

  # Process Future Game Row
  def futureGame(row, result)
    result << false	# Win
    result << 0	# boxscore_id
    row.children[0, 4].each_with_index do |cell, cnt|
      txt = cell.text.strip
      if cnt == 0 # Game Date
        result << txt.split(',')[1].strip
      elsif cnt == 1 				    # Home/Away, Opp tid
        saveHomeOpponent(cell, result, txt)
      elsif cnt == 2 				    # Game Time
        result << txt + ' ET'
      elsif cnt == 3 			    	# TV
        saveTV(cell, txt, result)
      end
    end
    # 		 Game Date, Game Time
    [result[4], result[7]]
  end

  # Store Home? and Opponent ID
  def saveHomeOpponent(cell, result, txt)
    result << !txt[0, 1].include?('@')	# Home Game?
    x0 = cell.children.children.children[1].attributes['href']
    result <<
      if x0.nil? # Non-NBA Team
        cell.children.children.children[1].text.strip
      else # NBA Team
        getTid(x0.text.split('/')[-1].split('-').join(' ')) # Opponent ID
      end
  end

  # Store Game Result
  # Win?, Team Score, Opponent Score, Boxscore ID
  def saveGameResult(cell, result, txt)
    win = (txt[0, 1].include?('W') ? true : false)
    final_score = txt[1, txt.length].gsub(/\s?\d?OT/, '')
    if win
      team_score, opp_score = final_score.split('-')
    else
      opp_score, team_score = final_score.split('-')
    end
    box_id = cell.children.children.children[1].attributes['href']
    result << win << team_score << opp_score # Win?, Team Score, Opponent Score
    result << (box_id.nil? ? 0 : box_id.text.split('=')[1]) # Boxscore ID
  end

  # Store Team Record
  # Wins, Losses
  def saveTeamRecord(result, season_type, ws, ls, text)
    if season_type == 3 # Team Record Playoffs
      result[7] ? ws += 1 : ls += 1
      result << ws << ls
    else # Team Record Pre/Regular
      wins, losses = text.split('-')
      result << wins << losses
    end
  end

  # Store TV?
  def saveTV(cell, txt, result)
    # Network image, link or name?
    result << %w(a img).include?(cell.children[0].node_name) || txt.size > 1
  end

  # Store Processed Schedule Row
  def saveProcessedScheduleRow(tmp, game_date, year1, game_time, season_type)
    return if tmp.nil?
    tmp << formatGameDate(game_date, year1, game_time) # Game DateTime
    tmp << season_type # Season Type
    @game_list << tmp # Save processed row
  end

  #  Adjust and format dates
  def formatGameDate(month_day, year, game_time = '00:00:00')
    year += 1 unless %w(Oct Nov Dec).include?(month_day.split[0])
    d = DateTime.parse(game_time + ' , ' + month_day + ',' + year.to_s)
    d.strftime('%Y-%m-%d %H:%M:%S') # Game DateTime String
  end
end
