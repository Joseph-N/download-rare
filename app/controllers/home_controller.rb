class HomeController < ApplicationController
  def index
  	@featured = Movie.all.sample
  	@movies = Movie.limit(9)
  	@shows = TvShow.limit(9)
  	@recently_updated_seasons= Season.where("updated_at > ?", 1.day.ago).reverse
  end
end
