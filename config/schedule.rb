every 1.day do
	rake "shows:update", :output => { :standard => 'shows-update.log' }
	command "backup perform -t downloadrare_db", :output => { :standard => '/home/Jose/download-rare/log/db_backup.log' }
end

every 2.days do
  rake "fetch:all_broken", :output => { :standard => '/home/Jose/download-rare/log/broken_links.log' }
end

every 1.day, :at => '8am' do
	rake "rake episodes:fetch_links", :output => { :standard => '/home/Jose/download-rare/log/episode_links.log' }
end

every :friday, :at => '12pm' do
	rake "movies:hunt", :output => { :standard => '/home/Jose/download-rare/log/movie_hunter.log' }
end


