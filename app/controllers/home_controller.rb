class HomeController < ApplicationController
  def index
  	@featured = Movie.all.sample
  	@movies = Movie.first(4)
  	@shows = TvShow.first(4)
  end
end
