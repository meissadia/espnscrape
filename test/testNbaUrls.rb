
class TestNbaUrls < Minitest::Test
  include NbaUrls
  def test_get_tid
    # Test all special cases
    tnames = ['Oklahoma City Thunder', 'Portland Trail Blazers', 'Brooklyn Nets', 'Utah Jazz', 'Jambo']
    expected = %w(OKC POR BKN UTA JAM)
    result = []
    tnames.each do |x|
      result << getTid(x)
    end
    # Validate TeamIDs were correctly derived
    assert_equal expected, result
  end

  def test_format_team_url
    teams = [%w(uta utah), %w(nop no), %w(sas sa), %w(was wsh), %w(pho phx), %w(gsw gs), %w(nyk ny)]
    url = '%s'
    teams.each do |team_id, expected|
      assert_equal expected, formatTeamUrl(team_id, url)
    end
  end
end
