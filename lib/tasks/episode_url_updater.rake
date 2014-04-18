namespace :episodes do
	desc "Fetches download links for episodes from parent directories"	
	task :fetch_links =>  [:environment] do
		Season.where.not("base_url IS ?", nil).each do |season|
			CrawlerWorker.perform_in(2.minutes, season.id, season.base_url)
			p "Fetch links for #{season.tv_show.name} S0#{season.season_number} Episodes.........OK"
		end
	end
end