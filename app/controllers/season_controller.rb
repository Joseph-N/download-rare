class SeasonController < ApplicationController

  def show
  	@tv_show = TvShow.friendly.find(params[:tv_show_id])
  	@season = @tv_show.seasons.where("season_number = ?", params[:id]).first
  	@season_info = @tmdb_tv.find_season(@tv_show.tmdb_id, @season.season_number)
  	@tv_show_info = @tmdb_tv.find(@tv_show.tmdb_id)
  end

  def update
  	@tv_show = TvShow.friendly.find(params[:tv_show_id])
  	@season = @tv_show.seasons.find(params[:id])
  	@season.update_attributes(season_params)
  	CrawlerWorker.perform_async(@season.id, params[:season][:base_url])
  	redirect_to tv_show_season_path(@tv_show, @season.season_number), notice: "success"
  end

  private
  def season_params
  	params.require(:season).permit(:base_url)
  end
end
