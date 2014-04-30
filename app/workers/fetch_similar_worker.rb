class FetchSimilarWorker
	include Sidekiq::Worker
	sidekiq_options :queue => :similar_movies, :retry => 2, :backtrace => true

	@@tmdbMovie = TmdbMovie.new("29588c40b1a3ef6254fd1b6c86fbb9a9")

	def perform(id)
		
		page_no = 0

		movie = Movie.find(id)
		results = @@tmdbMovie.similar_movies(movie.tmdb_id)

		if results["total_pages"] == 0
			movie.similar_movies = []
			movie.save!
		else
			total_pages = results["total_pages"] >= 1000 ? 1000 : results["total_pages"]
			
			until page_no == total_pages do
				page_no +=1
				SimilarMoviesWorker.perform_in(1.minute, movie.id, page_no)		
			end
		end  	
	end
end