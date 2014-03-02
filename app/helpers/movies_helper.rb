module MoviesHelper
	def movie_search_url
		admin_signed_in? ? search_movie_path : "/movies"
	end
end
