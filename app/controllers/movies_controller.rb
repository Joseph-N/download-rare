class MoviesController < ApplicationController
  def index
  	if params[:query]
  		@movies = Movie.plain_tsearch(params[:query])
  	else
  		@movies = Movie.all
  	end
  end

  def new
    @movie = Movie.new
  end

  def show
    @record = Movie.friendly.find(params[:id])
    @movie = @tmdb_movie.find(@record.tmdb_id)
    @trailer = @movie["trailers"]["youtube"][0]["source"] unless @movie["trailers"]["youtube"][0].nil?
    @backdrops = @movie["images"]["backdrops"]

  end

  def create
  	@movie = Movie.create(movie_params)
  	if @movie.save
  		redirect_to movies_path, notice: "Successfully saved movie"
    else
      render 'new'
  	end
  end


  private
  	def movie_params
		params.require(:movie).permit(:title, :tmdb_id, :poster, :backdrop, :release_date, :download_link)
	end

end
