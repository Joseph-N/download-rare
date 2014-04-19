class DownloadsController < ApplicationController
	def index
		if params[:resource] == "movie"
			@movie = Movie.find(params[:id])

			if params[:type] == "magnetic_link"
				redirect_to @movie.magnetic_link
			elsif params[:type] == "torrent_file"
				redirect_to @movie.torrent_file_link
			else
				redirect_to @movie.download_link
			end	

			@movie.increment!(:download_count)			
		elsif params[:resource] == "episode"
			@episode = Episode.find(params[:id])
			@download_link = DownloadLink.find(params[:link_id])
			@episode.increment!(:download_count)

			
			redirect_to @download_link.url
		end				
	end
end