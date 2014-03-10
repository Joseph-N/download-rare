class EpisodeWorker
  include Sidekiq::Worker
  
  def perform(episode_id)
    # fetch the move
    episode = Episode.find(episode_id)

    # escape url
    url = episode.download_link.gsub(/\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }

    # get headers
    headers =  RestClient.head(url).headers 

    #return content length header
    size =  headers[:content_length]

    #update episode
    episode.update_attribute(:file_size, size)
  end
end