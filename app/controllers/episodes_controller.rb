class EpisodesController < ApplicationController
	before_filter :authenticate_admin!
	
	def update
		@show = TvShow.friendly.find(params[:tv_show_id])
		@episode = Episode.find(params[:id])
		@season = Season.find(params[:season_id])
		if @episode.update_attributes(episode_params)	
			flash[:notice] = "successfully updated #{@show.name} S0#{@season.season_number}EP#{@episode.episode_number}"

			redirect_to tv_show_season_path(@show, @season.season_number)
		end	
	end

	def edit
		@show = TvShow.friendly.find(params[:tv_show_id])
		@season = Season.find(params[:season_id])
		@episode = Episode.find(params[:id])
	end

	private
		def episode_params
			params.require(:episode).permit(:download_link)
		end
end
