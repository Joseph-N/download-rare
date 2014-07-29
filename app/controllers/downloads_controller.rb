class DownloadsController < ApplicationController
	def index
		if params[:resource] == "movie"
			@movie = Movie.find(params[:id])
			@movie.increment!(:download_count)	

			if params[:type] == "magnetic_link"
				#DownloadMailer.notify("movie", @movie, "magnetic_link").deliver
				redirect_to @movie.magnetic_link
			elsif params[:type] == "torrent_file"
				#DownloadMailer.notify("movie", @movie, "torrent_file").deliver
				redirect_to @movie.torrent_file_link
			else
				#DownloadMailer.notify("movie", @movie, "Direct").deliver
				redirect_to @movie.download_link
			end	
					
		elsif params[:resource] == "episode"
			@episode = Episode.find(params[:id])
			@download_link = DownloadLink.find(params[:link_id])
			@episode.increment!(:download_count)

			#DownloadMailer.notify("episode", @episode, "Direct").deliver

			
			redirect_to @download_link.url
		end				
	end
end