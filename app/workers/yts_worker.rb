class YtsWorker
	include Sidekiq::Worker
	sidekiq_options :queue => :yts, :retry => 3, :backtrace => true
  
  	def perform(imdb_id)
  		@movie = TmdbMovie.new("29588c40b1a3ef6254fd1b6c86fbb9a9")
  		results = @movie.search_by_imdb_id(imdb_id)
  		# ensure we have some results
  		if results["movie_results"].size > 0
  			# this will be unique as imdb id is always unique (thus get the first)
  			movie_details = results["movie_results"][0]
  			# i'm only interested in movies released above year 2000
  			if movie_details["release_date"].to_date >= 14.years.ago
  				# create the movie
  				movie = Movie.where(:title => movie_details["original_title"],
                              :tmdb_id => movie_details["id"],
                              :release_date => movie_detail["release_date"]).first_or_create
          MovieWorker.perform_in(2.minutes, movie.id)
  			end
  		end
  	end
end