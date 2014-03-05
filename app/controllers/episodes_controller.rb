class EpisodesController < ApplicationController
	before_filter :authenticate_admin!
	
	def update
		@show = TvShow.friendly.find(params[:tv_show_id])
		@season = Season.find(params[:season_id])
		@episode = Episode.find(params[:id])
		if @episode.update_attributes(episode_params)	
			@show.update_attribute(:updated_at, @episode.updated_at)
			@season.update_attribute(:updated_at, @episode.updated_at)
			redirect_to tv_show_season_path(@show, @season.season_number)
		end	
	end

	private
		def episode_params
			params.require(:episode).permit(:download_link)
		end
end
