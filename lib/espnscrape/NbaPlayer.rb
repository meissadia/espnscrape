# Read basic bio info from ESPN Player page
class NbaPlayer
  include NbaUrls

  # @return [String]
  attr_accessor :name, :position, :age, :h_ft, :h_in, :college, :weight

  def initialize(espn_player_id)
    espn_player_id = espn_player_id.to_s
    unless (espn_player_id.empty?)
      url = playerUrl + espn_player_id
      doc = Nokogiri::HTML(open(url))
      if doc.nil?
        puts "URL Unreachable: " + url
        exit 1
      end
    end

    readInfo(doc)
  end

  private 
  # Extract basic bio info info class attributes
  def readInfo(d)
    @name = d.xpath("//div[@class='mod-content']/h1")[0].text.strip
    @position = d.xpath("//ul[@class='general-info']/li")[0].text.strip
    @college = d.xpath('//ul[contains(@class,"player-metadata")]/li/span[text() = "College"]/parent::li').text.gsub('College','')
    height, weight = d.xpath("//ul[@class='general-info']/li")[1].text.split(',')
    @weight = weight.strip.split(' ')[0]
    @h_ft, @h_in = height.strip.split('\'')
    @h_in = @h_in.gsub('"','').strip
  end

end
