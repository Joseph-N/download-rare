class SeasonsWorker
	include Sidekiq::Worker
	sidekiq_options :queue => :seasons, :retry => 3, :backtrace => true
  
  	def perform(season_id, episode_number, url)
      season = Season.find(season_id)
      episode = season.episodes.where("episode_number = ?", episode_number).first
      episode.update_attribute(:download_link, url) if episode.present?
  	end
end