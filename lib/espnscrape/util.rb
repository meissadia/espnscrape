# Debug Utilities

# Print an array as a CSV string
# @param args [[object]]
# @return [String]
def printCSV(*args)
	return args.join(', ')
end

# Print two dimensional array
# @param args [[[object]]] Table Data
# @param row_width [Integer] Row Width
def printTable(args, row_width=15, title='')
	spc = row_width
	puts title
	args.each do |row|
		row.each do |td|
			print td
			print " "*(spc - td.to_s.length) if ((spc - td.to_s.length) > 0)
		end
		puts
	end
end
