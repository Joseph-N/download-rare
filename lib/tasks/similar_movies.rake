namespace :movies do
	desc "Fetches for similar movies of a given movie"
	task :fetch_similar => [:environment] do
		tmdbMovie = TmdbMovie.new("29588c40b1a3ef6254fd1b6c86fbb9a9")
		wait_min = [2,4,6,8,10]

		Movie.find_each do |movie|
			page_no = 0
			results = tmdbMovie.similar_movies(movie.tmdb_id)

			total_pages = results["total_pages"]
			until page_no == total_pages do
				page_no +=1

				SimilarMoviesWorker.perform_in(wait_min.sample.minutes, movie.id, page_no)
			
			end
			p "Saved similar movies for >>> #{movie.title} <<< Total Pages: #{total_pages}"
		end
	end
end