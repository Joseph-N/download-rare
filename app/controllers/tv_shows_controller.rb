class TvShowsController < ApplicationController
  def index
  	if params[:query]
  		@tv_shows = TvShow.plain_tsearch(params[:query])
  	else
  		@tv_shows = TvShow.all
  	end
  end

  def new
    @tv_show = TvShow.new
  end

  def show
    @record = TvShow.friendly.find(params[:id])
    @show = @tmdb_tv.find(@record.tmdb_id)
    @backdrops 

  end

  def create
  	@tv_show = TvShow.create(tv_show_params)
  	if @tv_show.save
  		redirect_to tv_shows_path, notice: "Successfully saved show"
    else
      render 'new'
  	end
  end

  def season
    @show = TvShow.friendly.find(params[:id])
    @season = @tmdb_tv.find_season(@show.tmdb_id, params[:season_id])
  end


  private
  	def tv_show_params
		params.require(:tv_show).permit(:name, :tmdb_id, :poster, :backdrop, :release_date)
	end

end
