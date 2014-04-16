class SearchesController < ApplicationController
	before_filter :authenticate_admin!, only: [:index]
	def index
		@searches = Search.all
	end

	def create
		@search = Search.create(search_params)
		redirect_to @search
	end

	def show
		@search = Search.find(params[:id])
		@movies = @search.movies.paginate(:page => params[:page], :per_page => 20)
	end

	private
	def search_params
    	params.require(:search).permit(:title, :year, :genre, :rating)
    end
end