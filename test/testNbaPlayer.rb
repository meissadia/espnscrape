require 'minitest/autorun'
require_relative '../lib/espnscrape'

class TestNbaPlayer < Minitest::Test
  include NbaUrls
  def test_initialize
    player = EspnScrape.player(2991473)
    assert_equal "Anthony Bennett", player.name, "Player Name => Error"
    assert_equal "PF", player.position, "Player Position => Error"
    assert_equal "6", player.h_ft, "Player H_FT => Error"
    assert_equal "8", player.h_in, "Player H_IN => Error"
    assert_equal "245", player.weight, "Player Weight => Error"
    assert_equal "UNLV", player.college, "Player College => Error"

    player = EspnScrape.player(2531097)
    assert_equal "Keith Appling", player.name, "Player Name => Error"
    assert_equal "Michigan State", player.college, "Player College => Error"
    assert_equal "PG", player.position, "Player Position => Error"
  end
end
