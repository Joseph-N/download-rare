namespace :movies do
	desc "Fetches for similar movies of a given movie"
	task :fetch_similar => [:environment] do
		tmdbMovie = TmdbMovie.new("29588c40b1a3ef6254fd1b6c86fbb9a9")

		movie = Movie.where("? = ANY (similar_movies)","")

		page_no = 0
		results = tmdbMovie.similar_movies(movie.tmdb_id)
		total_pages = results["total_pages"]
		
		until page_no == total_pages do
			page_no +=1

			SimilarMoviesWorker.perform_async(movie.id, page_no)
			# pause 10 seconds before continuing
			sleep 1
		
		end
		p "Saved similar movies for >>> #{movie.title} <<< Total Pages: #{total_pages}"
	end
end