require 'rubygems'
require 'nokogiri'
require 'open-uri'

class CrawlerWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :crawler, :retry => false, :backtrace => true
  
  def perform(season_id, url)
    base_url = "http://dl.popbrap.org"

    doc = Nokogiri::HTML(open(url))

    doc.css("br+ a").each_with_index do |entry, index|
      full_url = base_url + entry["href"]
      episode_number = index +=1
      SeasonsWorker.perform_async(season_id, episode_number, full_url)
    end

  end
end