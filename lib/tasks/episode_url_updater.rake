namespace :episodes do
	desc "Fetches download links for episodes from parent directories"	
	task :fetch_links =>  [:environment] do
		BaseUrl.find_each do |base_url|
			wait = [1,2,3,4,5,6]
			CrawlerWorker.perform_in(wait.sample.minutes, base_url.season.id, base_url.url)
			p "Fetch links for #{base_url.season.tv_show.name} S0#{base_url.season.season_number} Episodes.........OK"
		end
	end
end