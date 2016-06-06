require 'minitest/autorun'
require_relative '../lib/espnscrape'

class TestNbaPlayer < Minitest::Test
  include NbaUrls
  def test_file_data
    player = NbaPlayer.new('', 'test/playerBennett.html')
    assert_equal "Anthony Bennett", player.name,     "Player Name => Error"
    assert_equal "PF",              player.position, "Player Position => Error"
    assert_equal 6,                 player.h_ft,     "Player H_FT => Error"
    assert_equal 8,                 player.h_in,     "Player H_IN => Error"
    assert_equal 245,               player.weight,   "Player Weight => Error"
    assert_equal "UNLV",            player.college,  "Player College => Error"
    assert_equal 23,                player.age,      "Player Age => Error"
  end

  def test_live_data
    player = EspnScrape.player(1966)
    assert_equal "LeBron James", player.name,     "Player Name => Error"
    assert_equal "None",         player.college,  "Player College => Error"
    assert_equal "SF",           player.position, "Player Position => Error"
    assert_equal 31,             player.age,      "Player Age => Error"
    assert_equal 6,              player.h_ft,     "Player H_FT => Error"
    assert_equal 8,              player.h_in,     "Player H_IN => Error"
    assert_equal 250,            player.weight,   "Player Weight => Error"
  end

  def test_live_non_nba
    # Test Non-NBA Player
    player = EspnScrape.player(2233514)
    player = EspnScrape.player(2995725)
    player = EspnScrape.player(2585991)
    assert_equal 0, player.age, "Player Age => Error"
    player = EspnScrape.player(3945381)
  end
end
