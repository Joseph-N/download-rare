class DownloadsController < ApplicationController
	def index
		if params[:resource] == "movie"
			@movie = Movie.find(params[:id])
			redirect_to @movie.download_link
		elsif params[:resource] == "episode"
			@episode = Episode.find(params[:id])
			redirect_to @episode.download_link
		end				
	end
end