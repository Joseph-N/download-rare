class SearchController < ApplicationController
	before_filter :authenticate_admin!

	def movie
		@movies = @tmdb_movie.search(params[:query])
		@movie = Movie.new		
	end

	def tv
		@shows = @tmdb_tv.search(params[:query])
		@tv_show = TvShow.new
	end
end