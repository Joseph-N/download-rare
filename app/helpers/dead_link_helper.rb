module DeadLinkHelper
	def get_movie(id)
		Movie.find(id)
	end

	def fetch_episode(id)
		Episode.find(id)
	end
end
