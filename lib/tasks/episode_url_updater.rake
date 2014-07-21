namespace :episodes do
	desc "Fetches download links for episodes from parent directories"	
	task :fetch_links =>  [:environment] do
		wait = [1,2,3,4,5,6]

		TvShow.find_each do |show|
			# only update latest season
			latest_season = show.seasons.last

			unless latest_season.nil?
				puts "Fetching new episodes of #{latest_season.tv_show.name} S0#{latest_season.season_number}"

				# check new episodes of latest season
				latest_season.base_urls.each do |base_url|
					CrawlerWorker.perform_in(wait.sample.minutes, latest_season.id, base_url.url)
				end
			else
				puts "No latest season for #{show.name}"
			end
		end
	end
end