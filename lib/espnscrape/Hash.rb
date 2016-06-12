# Extend Hash
class Hash
  # Get an NbaBoxscore
  # @param [Symbol] Format
  # @return [NbaBoxscore] Boxscore
  def boxscore(f_mat = nil)
    EspnScrape.boxscore(self[:boxscore_id], (f_mat || :to_hashes))
  end
end
