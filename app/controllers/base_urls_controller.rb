class BaseUrlsController < ApplicationController
	def create
		@show = TvShow.friendly.find(params[:tv_show_id])
		@season = @show.seasons.where("season_number = ?", params[:season_id]).first
		@base_url = @season.base_urls.create(base_url_params)
		if @base_url.save
			CrawlerWorker.perform_in(2.minutes, @season.id,@base_url.url)
			redirect_to tv_show_season_path(@show, @season), notice: "success"
		else
			redirect_to tv_show_season_path(@show, @season), alert: "URL Must be unique | present"
		end
	end

	private
	def base_url_params
		params.require(:base_url).permit(:url)
	end
end