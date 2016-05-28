# Debug Utilities
class Util
	# Print an array as a string
	# @param args [[object]]
	# @return [String]
	def self.a_to_s(*args)
		return args.join(', ')
	end

	# Print two dimensional array as a string
	# @param args [[[object]]]
	# @param row_width [Integer]
	def self.a2_to_table(args, row_width=30)
		spc = row_width
		puts ""
		args.each do |row|
			row.each do |td|
				print td
				if((spc - td.to_s.length) > 0)
					print " "*(spc - td.to_s.length)
				end
			end
			puts
		end
	end

	# NbaBoxScore: Print totals row
	# @param teamTotals [[Integer]]
	# @return [String]
	def self.printTotals(teamTotals)
		print "Totals:\t\t\t\t\t\t\t\t\t\t"
		teamTotals.each do |cell|
			print "\t\t" + cell + "\t|| "
		end
		puts "\n\n"
	end

end
