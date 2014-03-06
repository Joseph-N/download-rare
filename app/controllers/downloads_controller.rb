class DownloadsController < ApplicationController
	def index
		if params[:resource] == "movie"
			@movie = Movie.find(params[:id])
			@movie.increment!(:download_count)

			redirect_to @movie.download_link
		elsif params[:resource] == "episode"
			@episode = Episode.find(params[:id])
			@episode.increment!(:download_count)
			
			redirect_to @episode.download_link
		end				
	end
end