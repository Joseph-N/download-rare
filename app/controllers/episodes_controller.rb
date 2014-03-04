class EpisodesController < ApplicationController
	def update
		@show = TvShow.find(params[:tv_show_id])
		@season = Season.find(params[:season_id])
		@episode = Episode.find(params[:id])
		if @episode.update_attributes(episode_params)	
			redirect_to tv_show_season_path(@show, @season.season_number)
		end	
	end

	private
		def episode_params
			params.require(:episode).permit(:download_link)
		end
end
