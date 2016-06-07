# Debug Utilities
module DebugUtils
	# Printable tabular String representation of args data
	# @param args [[[object]]] Table Data
	# @param row_width [Integer] Row Width
	# @return [String] Table String
	def asTable(args, row_width=15, title='', show_idx=false)
		result = "\n#{title}\n"
		spc = row_width
		idx_width = args.size.to_s.length
		args.each_with_index do |row, idx|
			result += "#{idx}." + " "*(idx_width - idx.to_s.length) + "  " if show_idx
			row.each do |td|
				result += td.to_s
				result+= " "*(spc - td.to_s.length) if ((spc - td.to_s.length) > 0)
			end
			result += "\n"
		end
		return result
	end
end
