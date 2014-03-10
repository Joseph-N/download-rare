set :output, "/home/Jose/download-rare/log/cron_log.log"
set :environment, 'production'

every 1.day do
	rake "shows:update"
end


every :monday, :at => '1am' do
  rake "fetch:all_broken"
end
