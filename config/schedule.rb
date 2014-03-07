set :output, "/home/Jose/download-rare/log/cron_log.log"
set :environment, 'production'

every 1.day do
	rake "shows:update"
end

