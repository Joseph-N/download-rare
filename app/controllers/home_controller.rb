class HomeController < ApplicationController

	def index
		@featured = Movie.where("imdb_rating >= ?", 5).sample
		@movies = Movie.limit(9)
		@shows = TvShow.limit(9)
		@recently_updated_episodes = Episode.limit(10)
	end
end
