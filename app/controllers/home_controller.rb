class HomeController < ApplicationController
  def index
  	@featured = Movie.all.sample
  	@movies = Movie.first(9)
  	@shows = TvShow.first(9)
  end
end
