module TvShowsHelper
	def tv_search_url
		admin_signed_in? ? search_tv_path : "/tv_shows"
	end
end
