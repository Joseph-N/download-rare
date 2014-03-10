class CustomWorker
  include Sidekiq::Worker
  
  def perform
    #movies
    Movie.all.each do |movie|
      url = movie.download_link.gsub(/\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }
      # get headers
      headers =  RestClient.head(url).headers 

      #return content length header
      size =  headers[:content_length]

      #update movie
      movie.update_attribute(:file_size, size)
    end

    #episodes
    Episode.where.not("download_link is ?", nil).each do |episode|
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
end