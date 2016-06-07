require 'date'
require_relative './DebugUtils.rb'

# Access NBA boxscore data
class NbaBoxScore
  include NbaUrls
  include DebugUtils

  # @return [String] Game Date
  attr_accessor :gameDate

  # @return [String] Away Team Name
  attr_accessor :awayName

  # @return [[[Integer]]] Away Team Stats Array
  # @see EspnScrape::FS_BOXSCORE
  attr_accessor :awayPlayers

  # @return [[Integer]] Away Team Combined Stats
  # @see EspnScrape::FS_BOXSCORE_TOTALS
  attr_accessor :awayTotals

  # @return [String] Home Team Name
  attr_accessor :homeName

  # @return [[[Integer]]] Home Team Stats Array
  # @see EspnScrape::FS_BOXSCORE
  attr_accessor :homePlayers

  # @return [[Integer]] Home Team Combined Stats
  # @see EspnScrape::FS_BOXSCORE_TOTALS
  attr_accessor :homeTotals

  # Scrape Box Score Data
  # @param game_id [Integer] Boxscore ID
  # @example
  # 	bs = NbaBoxScore.new(400828035)
  def initialize(game_id, file = '')
    doc = getNokoDoc(game_id, file)
    exit if doc.nil?

    @gameDate = readGameDate(doc)
    @awayName, @homeName = readTeamNames(doc)
    return unless @gameDate.index('00:00:00') # Only past games have stats
    @awayPlayers, @awayTotals = readTeamStats(doc, 'away')
    @homePlayers, @homeTotals = readTeamStats(doc, 'home')
  end

  private

  def getNokoDoc(game_id, file)
    return Nokogiri::HTML(open(file)) if game_id.nil? # Parse File
    Nokogiri::HTML(open(boxScoreUrl + game_id.to_s)) # Parse URL
  end

  # Reads the game date from a Nokogiri::Doc
  # @param d [Nokogiri::HTML::Document]
  # @return [String] Game date
  # @example
  # 	bs.readGameDate(doc) #=> "Mon, Nov 23"
  # @note
  # 	Times will be Local to the system Timezone
  #
  def readGameDate(d)
    # Should be YYYY-MM-DD HH:MM:00
    time = d.xpath('//span[contains(@class,"game-time")]')[0].text.strip
    date = d.title.split('-')[2].delete(',')

    # Future game time is populated via AJAX, so may not be available at the
    # time the HTML is processed
    if time.empty?
      utc_datetime = d.xpath('//span[contains(@class,"game-time")]/parent::span').first.attribute('data-date').text
      utc_datetime = DateTime.parse(utc_datetime).new_offset(DateTime.now.offset)
      return utc_datetime.strftime('%Y-%m-%d %H:%M:%S')
    end

    # Past games have no displayed time
    time = '00:00:00' if time == 'Final'

    DateTime.parse(date + ' ' + time).strftime('%Y-%m-%d %H:%M:%S')
  end

  # Reads the team names from a Nokogiri::Doc
  # @param d [Nokogiri::HTML::Document]
  # @return [String, String] Team 1, Team 2
  # @example
  # 	bs.readGameDate(doc)
  #
  def readTeamNames(d)
    names = d.xpath('//div[@class="team-info"]/*/span[@class="long-name" or @class="short-name"]')
    away = names[0].text + ' ' + names[1].text
    home = names[2].text + ' ' + names[3].text
    [away, home]
  end

  # Extract Player Stats
  # @param row [[Nokogiri::XML::NodeSet]] Cumulative Team Stats
  # @param tid [String] Team ID
  # @return [[String]]  Processed Team Stats
  def processPlayerRows(rows, tid)
    result = [] # Extracted Player Data
    rows.each_with_index do |row, index|
      curr_row = [tid, '0']	# Team ID, Game ID

      row.children.each do |cell|	# Process Columns
        c_val = cell.text.strip
        case cell.attribute('class').text
        when 'name'
          curr_row << cell.children[0].attribute('href').text[%r{id/(\d+)}, 1] # Player ID
          curr_row << cell.children[0].text.strip # Player Short Name (i.e. D. Wade)
          curr_row << cell.children[1].text.strip # Position
        when 'fg', '3pt', 'ft'
          # Made-Attempts
          curr_row += c_val.split('-')
        else
          curr_row << c_val
        end
      end

      curr_row << 'X' if index < 5 # Check if Starter
      result << curr_row           # Save processed data
    end
    result
  end

  # Extract Team Stats
  # @param row [[Nokogiri::XML::NodeSet]] Cumulative Team Stats
  # @param tid [String]  Team ID
  # @return [[String]]   Processed Team Stats
  def processTeamRow(row, tid)
    result = []
    row.children.each do |cell|
      c_val = cell.text.strip
      case cell.attribute('class').text
      when 'name'
        result << tid
      when 'fg', '3pt', 'ft'
        # Made-Attempts
        result += c_val.split('-')
      else
        next if c_val.empty?
        result << c_val
      end
    end
    result
  end

  # Reads the team stats from a Nokogiri::Doc
  # @param d [Nokogiri::HTML::Document]
  # @param id [String] Team selector -> home/away
  # @return [String] Game date
  # @example
  # 	bs.readTeamStats(doc,'away')
  #
  def readTeamStats(d, id)
    # Extract player tables
    p_tables = d.xpath('//div[@class="sub-module"]/*/table/tbody')
    if p_tables.nil? || p_tables.empty?
      puts 'No Game Data Available'
      return [], []
    end

    if id == 'away'
      p_tab = p_tables[0, 2]
      tid = getTid(@awayName)
    else
      p_tab = p_tables[2, 4]
      tid = getTid(@homeName)
    end

    player_rows = p_tab.xpath('tr[not(@class)]') # Ignore TEAM rows
    team_row    = p_tab.xpath('tr[@class="highlight"]')[0] # Ignore Percentage row

    player_stats = processPlayerRows(player_rows, tid)
    team_totals  = processTeamRow(team_row, tid)

    [player_stats, team_totals]
  end
end
