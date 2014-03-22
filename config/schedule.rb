set :output, "/home/Jose/download-rare/log/cron_log.log"

every 1.day do
	rake "shows:update", :output => { :standard => 'shows-update.log' }
	command "backup perform -t downloadrare_db", , :output => { :standard => 'db_backup.log' }
end

every 2.days do
  rake "fetch:all_broken", :output => { :standard => 'broken_links.log' }
end

every :friday, :at => '12pm' do
	rake "movies:hunt", :output => { :standard => 'movie_hunter.log' }
end


