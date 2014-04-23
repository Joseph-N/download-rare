namespace :movies do
	desc "Fetches for similar movies of a given movie"
	task :fetch_similar => [:environment] do
		tmdbMovie = TmdbMovie.new("29588c40b1a3ef6254fd1b6c86fbb9a9")

		movie = Movie.where(:similar_movies => nil).first


		page_no = 0
		results = tmdbMovie.similar_movies(movie.tmdb_id)

		# only 5 pages		
		until page_no == 5 do
			page_no +=1

			SimilarMoviesWorker.perform_async(movie.id, page_no)
			# pause 1 seconds before continuing
			sleep 1
		
		end
		p "Saved similar movies for >>> #{movie.title} <<< Total Pages: #{total_pages}"
	end
end
