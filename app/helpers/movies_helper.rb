module MoviesHelper
	def return_year(string_date)
		unless string_date.nil?
			string_date.to_date.strftime('%Y')
		else
			"N/A"
		end
	end

	def options_for_rating
		(1...10).to_a.map {|x| [x.to_s + '+', x.to_f] }
	end

	def options_for_year
		Movie.select("release_date").map{ |movie| movie.release_date.year }.uniq.sort.reverse
	end
end
