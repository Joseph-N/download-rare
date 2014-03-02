class SearchController < ApplicationController
	def movie
		@movies = @tmdb_movie.search(params[:query])
		@movie = Movie.new		
	end

	def tv
		@shows = @tmdb_tv.search(params[:query])
		@tv_show = TvShow.new
	end
end