module SeasonHelper
	def get_episode(tv_show_id, season_number, episode_number)
		TvShow.find(tv_show_id).
		seasons.where("season_number = ?", season_number).
		first.episodes.where("episode_number = ?", episode_number).first
	end

	def episode_has_link?(*args)
		get_episode(*args).download_link.nil?
	end

	def add_download_class?(episode)
		admin_signed_in? && !episode.download_link.nil?
	end
end
