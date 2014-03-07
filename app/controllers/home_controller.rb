class HomeController < ApplicationController
  def index
  	@featured = Movie.where("download_count = ?", Movie.maximum(:download_count)).first
  	@movies = Movie.limit(9)
  	@shows = TvShow.limit(9)
  	@recently_updated_episodes = Episode.limit(10)
  end
end
