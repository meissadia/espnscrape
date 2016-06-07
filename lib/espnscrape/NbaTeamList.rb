# Access list of NBA teams
class NbaTeamList
  include NbaUrls
  include DebugUtils

  # @return [String] Table Title
  attr_accessor :header

  # @return [[[String]]] Table of NBA Teams
  # @note (see EspnScrape::FS_TEAM)
  attr_accessor :teamList

  # Scrape Team Data
  # @return [[String]] Resulting Team List
  def initialize(file = '')
    doc = file.empty? ? Nokogiri::HTML(open(teamListUrl)) : Nokogiri::HTML(open(file))
    exit if doc.nil?

    # Collect
    @header = doc.xpath('//h2')[0].text.strip # Table Header
    team_names = doc.xpath('//h5/a/text()')   # Team Names

    @teamList = []
    h = 0 # Head of teamNames range
    west_conf = %w(Northwest Pacific Southwest) # Western Conference Divs
    # Process Teams by Division
    divs = %w(Atlantic Pacific Central Southwest Southeast Northwest)
    divs.each do |div|
      processTeams(div, team_names[h, 5], west_conf, @teamList) # Store Team Data
      h += 5
    end
  end

  private

  # Derive TeamID, Division, Conference
  # @param division [String] Division Name
  # @param team_names [[String]] List of Team Names
  # @param west_conf [[String]] List of Divisions in the Western Conference
  # @param tl [[String]] List to which rows of TeamList are appended
  # @example
  # 	processTeams("Atlantic", ["Boston Celtics"], [...], result)
  # 	#result[n] = [TeamID, TeamName, TeamDiv, TeamConf]
  # 	result[0] = ["BOS", "Boston Celtics", "Atlatic", "Eastern"]
  def processTeams(division, team_names, west_conf, tl)
    team_names.each do |tname|
      tmp  = []	# Stage Team Data
      full = tname.text.strip	# Full Team Name
      tmp << getTid(full)	# Derive Team Abbreviation
      tmp << full.strip
      tmp << division

      # Derive Conference from Division
      tmp << (west_conf.include?(division) ? 'Western' : 'Eastern')
      tl << tmp # Save Team Data to global @teamList[]
    end
  end
end
