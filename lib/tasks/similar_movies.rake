namespace :movies do
	desc "Fetches for similar movies of a given movie"
	task :fetch_similar => [:environment] do
		tmdbMovie = TmdbMovie.new("29588c40b1a3ef6254fd1b6c86fbb9a9")

		movie = Movie.where(:similar_movies => nil).first


		page_no = 0
		results = tmdbMovie.similar_movies(movie.tmdb_id)

		if results["total_pages"] == 0
			movie.similar_movies = []
			movie.save!
		else
			total_pages = results["total_pages"] >= 1000 ? 1000 : results["total_pages"]
			
			until page_no == to do
				page_no +=1
				p "Fetching results page ----> #{page_no}"
				SimilarMoviesWorker.perform_async(movie.id, page_no)		
			end
			p "Saved similar movies for >>> #{movie.title} <<< Total Pages: #{total_pages}"
		end
	end
end
