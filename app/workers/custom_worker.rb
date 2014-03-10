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
    Episode.where("file_size is ? and download_link is not ?", nil, nil).each do |episode|
      # escape url
      url = episode.download_link.gsub(/\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }

      # get headers
      begin
         headers =  RestClient.head(url).headers 

        #return content length header
        size =  headers[:content_length]
              
      rescue
        p "Error: id:#{episode.id} #{episode.season.tv_show.name} S0#{episode.season.season_number}E#{episode.episode_number} link missing #{episode.download_link}"
        
      end    

      #update episode
      episode.update_attribute(:file_size, size)

      p "updated #{episode.season.tv_show.name} S0#{episode.season.season_number}E#{episode.episode_number}"
    end

  end
end