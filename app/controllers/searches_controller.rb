class SearchesController < ApplicationController
	before_filter :authenticate_admin!, only: [:movie, :tv]
	
	def index
		@shows = TvShow.plain_tsearch(params[:query])
		@movies = Movie.plain_tsearch(params[:query]) 
	end

	def create
		@search = Search.create(search_params)
		redirect_to @search
	end

	def show
		@search = Search.find(params[:id])
		@movies = @search.movies.paginate(:page => params[:page], :per_page => 20)
	end

	def movie
		@movies = @tmdb_movie.search(params[:query])
		@movie = Movie.new		
	end

	def tv
		@shows = @tmdb_tv.search(params[:query])
		@tv_show = TvShow.new
	end

	private
	def search_params
    	params.require(:search).permit(:title, :year, :genre, :rating)
    end
end