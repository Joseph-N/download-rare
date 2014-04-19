class DownloadLinksWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :download_links, :retry => 5, :backtrace => true 
  
  def perform(id)
    # fetch the move
    download_link = DownloadLink.find(id)

    # escape url
    url = download_link.url.gsub(/\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }

    # get headers
    headers =  RestClient.head(url).headers 

    #return content length header
    size =  headers[:content_length]

    #update episode
    download_link.update_attribute(:file_size, size)
  end
end