class SeasonController < ApplicationController
  def show
  	@tv_show = TvShow.friendly.find(params[:tv_show_id])
  	@season = @tv_show.seasons.where("season_number = ?", params[:id]).first
  	@season_info = @tmdb_tv.find_season(@tv_show.tmdb_id, @season.season_number)
  	@tv_show_info = @tmdb_tv.find(@tv_show.tmdb_id)
  end
end
