set :output, "/home/Jose/download-rare/log/cron_log.log"
set :environment, 'production'

every 1.day do
	rake "shows:update"
end

every 2.days do
  rake "fetch:all_broken"
end

every :friday, :at => '12pm' do
	rake "movies:hunt"
end

