module MoviesHelper
	def movie_search_url
		admin_signed_in? ? search_movie_path : "/movies"
	end

	def return_year(string_date)
		string_date.to_date.strftime('%Y')
	end

	def options_for_rating
		(1...10).to_a.map {|x| x.to_s + '+' }
	end

	def options_for_year
		Movie.select("release_date").map{ |movie| movie.release_date.year }.uniq
	end
end
