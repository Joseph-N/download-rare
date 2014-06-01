class CrawlerWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :crawler, :retry => 5, :backtrace => true 
  
  require 'open-uri'
  
  def perform(season_id, url)
    wait = [1,2,3,4]
    blacklist = ["php","jpg","png","html"]

    doc = Nokogiri::HTML(open(url))

    # for popbrap parent directory
    if doc.css("br+ a").size > 0
      base_url = "http://dl.popbrap.org"

      doc.css("br+ a").each_with_index do |entry, index|
        format = entry["href"].split('.').last
        unless blacklist.include?(format)
          full_url = base_url + entry["href"]
          episode_number = index +=1
          SeasonsWorker.perform_in(wait.sample.minutes, season_id, episode_number, full_url)
        end
      end

    # for http://192.0.135.29/ parent directory
    elsif doc.css("tr+ tr a").size > 0

      doc.css("tr+ tr a").each_with_index do |entry, index|
        format = entry["href"].split('.').last
        unless blacklist.include?(format)
          full_url = url + entry["href"]
          episode_number = index +=1
          SeasonsWorker.perform_in(wait.sample.minutes, season_id, episode_number, full_url)
        end
      end      

    # for http://dl1.m-dl.in/
    elsif doc.css("a+ a").size > 0      
      doc.css("a+ a").each_with_index do |entry, index|
        format = entry["href"].split('.').last
        unless blacklist.include?(format)
          full_url = url + entry["href"]
          episode_number = index +=1
          SeasonsWorker.perform_in(wait.sample.minutes, season_id, episode_number, full_url)
        end
      end

    # for http://dl1.m-dl.in/ other differently formated pages
    elsif doc.css("a").size > 0      
      doc.css("a").each_with_index do |entry, index|
        format = entry["href"].split('.').last
        unless blacklist.include?(format)
          full_url = url + entry["href"].sub("./","")
          episode_number = index +=1
          SeasonsWorker.perform_in(wait.sample.minutes, season_id, episode_number, full_url)
        end
      end
    end
  end
end
