class SimilarMoviesWorker
	include Sidekiq::Worker
	sidekiq_options :queue => :similar_movies, :retry => 3, :backtrace => true

	def perform(id, page_no)
		# initialize tmdbmove
		tmdbMovie = TmdbMovie.new("29588c40b1a3ef6254fd1b6c86fbb9a9")

		# find the movie with the given id
		movie = Movie.find(id)

		# minimum date for movies
		base_date = Date.new(2000)

		# array to hold tmdb_ids
		tmdb_ids = []

		# get similar movies
		similar_movies = tmdbMovie.similar_movies(movie.tmdb_id, page_no)
		similar_movies["results"].collect do |result|
			result_date =  result["release_date"].to_date 
			result_id = result["id"]

			unless result_date.nil?
				if result_date >= base_date
					# look if movie exist in the database
					match = Movie.where(:tmdb_id => result_id)

					# if found match
					if match.any?
						tmdb_ids << result_id
					end
				end 
			end
		end

		if movie.similar_movies.nil?
			movie.similar_movies = tmdb_ids
		else
			movie.similar_movies += tmdb_ids
		end

		#save movie
		movie.save!
	end
end