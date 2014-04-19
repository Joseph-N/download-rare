class SeasonsWorker
	include Sidekiq::Worker
	sidekiq_options :queue => :seasons, :retry => 3, :backtrace => true
  
  	def perform(season_id, episode_number, url)
      season = Season.find(season_id)
      episode = season.episodes.where("episode_number = ?", episode_number).first
      if episode.present?
      	download_link = episode.download_links.where(:url => url).first_or_create!
      	DownloadLinksWorker.perform_in(4.minutes, download_link.id)
      end
  	end
end