class MoviesController < ApplicationController
  before_filter :authenticate_admin!, only: [:create, :edit, :update]
  
  def index
      # @movies = Movie.plain_tsearch(params[:query]).paginate(:page => params[:page], :per_page => 12) 
      if params[:genre]
        @movies = Movie.where("? = ANY (genres)", params[:genre]).paginate(:page => params[:page], :per_page => 36)
      else       
        @movies = Movie.paginate(:page => params[:page], :per_page => 36)
      end
      @genres = fetch_genres.flatten.uniq
  end

  def new
    @movie = Movie.new
  end

  def show
    @record = Movie.friendly.find(params[:id])
    @movie = @tmdb_movie.find(@record.tmdb_id)
    if @movie["trailers"]
      @trailer = @movie["trailers"]["youtube"][0]["source"] unless @movie["trailers"]["youtube"][0].nil?
    end
    @backdrops = @movie["images"]["backdrops"]
    @torrent = @yts.find(@record.imdb_id)["MovieList"][0] if @record.magnetic_link
    @genres = fetch_genres.flatten.uniq
    @similar_movies = Movie.where(:tmdb_id => @record.similar_movies.sample(6)) unless @record.similar_movies.nil?
  end

  def create
  	@movie = Movie.create(movie_params)
  	if @movie.save
      MovieWorker.perform_async(@movie.id)
  		redirect_to movies_path, notice: "Successfully saved movie"
    else
      render 'new'
  	end
  end

  def edit
     @movie = Movie.friendly.find(params[:id])
  end

  def update
    @movie = Movie.friendly.find(params[:id])
    if @movie.update_attributes(movie_params)
      remove_movie_from_broken_links(@movie.id)
      MovieWorker.perform_async(@movie.id)
      
      redirect_to @movie, :notice => "Successfully updated #{@movie.title}"
    end
  end

  def similar
    @movie = Movie.friendly.find(params[:id])
    @genres = fetch_genres.flatten.uniq
    @similar_movies = Movie.where(tmdb_id: @movie.similar_movies).paginate(:page => params[:page], :per_page => 32)
  end


  private
  def movie_params
		params.require(:movie).permit(:title, :tmdb_id, :poster, :backdrop, :release_date, :download_link, :magnetic_link, :torrent_file_link)
	end

  def remove_movie_from_broken_links(id)
    movie = DeadLink.find_by resource_id: id
    if movie.present?
      movie.destroy
    end
  end
end
