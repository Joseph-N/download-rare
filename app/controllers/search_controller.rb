class SearchController < ApplicationController
	before_filter :authenticate_admin!, except: [:index]

	def index
		@shows = TvShow.plain_tsearch(params[:query])
		@movies = Movie.plain_tsearch(params[:query]) 
	end

	def movie
		@movies = @tmdb_movie.search(params[:query])
		@movie = Movie.new		
	end

	def tv
		@shows = @tmdb_tv.search(params[:query])
		@tv_show = TvShow.new
	end
end