class TvShowsController < ApplicationController
  before_filter :authenticate_admin!, only: [:create]
  def index
  	if params[:query]
      @tv_shows = TvShow.plain_tsearch(params[:query])
  	else
  		@tv_shows = TvShow.limit(13)
  	end
  end

  def new
    @tv_show = TvShow.new
  end

  def show
    @record = TvShow.friendly.find(params[:id])
    @show = @tmdb_tv.find(@record.tmdb_id)
  end

  def create
  	@tv_show = TvShow.create(tv_show_params)
  	if @tv_show.save
      TvWorker.perform_async(@tv_show.id)

  		redirect_to tv_shows_path, notice: "Successfully saved show"
    else
      render 'new'
  	end
  end

  private
  	def tv_show_params
		params.require(:tv_show).permit(:name, :tmdb_id, :poster, :backdrop, :release_date, :number_of_seasons, :number_of_episodes)
	end

end
