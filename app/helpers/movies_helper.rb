module MoviesHelper
	def movie_search_url
		admin_signed_in? ? search_movie_path : "/movies"
	end

	def return_year(string_date)
		string_date.to_date.strftime('%Y')
	end
end
