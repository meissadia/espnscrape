# Debug Utilities
module DebugUtils
  # Printable tabular String representation of args data
  # @param args [[[object]]] Table Data
  # @param col_width [Integer] Column Width
  # @return [String] Table String
  def asTable(args, col_width = 15, title = '', show_idx = false)
    result = "\n#{title}"
    idx_width = args.size.to_s.length
    args.each_with_index do |row, idx|
      result << "\n#{idx}." + ' ' * pad(idx_width, idx) + '  ' if show_idx
      formatRow(row, col_width, result)
    end
    result
  end

  private

  def pad(width, content)
    (width - content.to_s.length) > 0 ? (width - content.to_s.length) : 0
  end

  def formatRow(row, width, target)
    row.each do |td|
      target << td.to_s
      target << ' ' * pad(width, td) if pad(width, td) > 0
    end
  end
end
