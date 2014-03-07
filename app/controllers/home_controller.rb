class HomeController < ApplicationController
  def index
  	@featured = Movie.all.sample
  	@movies = Movie.limit(9)
  	@shows = TvShow.limit(9)
  	@recently_updated_seasons= Season.unscoped.where("updated_at > ?", 2.weeks.ago).limit(10).reverse
  end
end
