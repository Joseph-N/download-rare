class MovieWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :movie, :retry => false, :backtrace => true
  
  def perform(movie_id)

    # new TmdbTv instance
    @movie = TmdbMovie.new("29588c40b1a3ef6254fd1b6c86fbb9a9")

    # new yts instance
    @yts = YtsTorrents.new

    #-----------------------GET SIZE OF MOVIE FROM SERVER HEADERS----------------------#
  	# fetch the movie
  	movie = Movie.find(movie_id)

    if movie.download_link.present?
    	# escape url
    	url = movie.download_link.gsub(/\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }

    	# get headers
  	    headers =  RestClient.head(url).headers 

    	#return content length header
    	size =  headers[:content_length]
    else
      size = nil
    end


    #-----------------------GET GENRE  & IMDB ID OF MOVIE ----------------------#

    # get movie details
    movie_detail = @movie.find(movie.tmdb_id)

    # get genres
    genres = movie_detail["genres"].collect {|x| x["name"] }

    # get imdb_id
    imdb_id = movie_detail["imdb_id"]


    #---------------------GET MAGNETIC LINKS AND TORRENT FILE FROM YIFY TORRENTS-----------------------#

    torrent_detail = @yts.find(imdb_id)

    magnetic_link = torrent_detail["status"].eql?("fail") ? nil : torrent_detail["MovieList"][0]["TorrentMagnetUrl"]
    torrent_file_link = torrent_detail["status"].eql?("fail") ? nil : torrent_detail["MovieList"][0]["TorrentUrl"]

    #-------------------GET IMDBRATING OF MOVIE-----------------------------------#
    imdb_data =  JSON.parse(RestClient.get "http://www.omdbapi.com/?i=#{imdb_id}")
    rating = imdb_data["imdbRating"]


    #------------ Finally update movie ----------------------------#
    #update movie
    movie.update_attributes(:backdrop => movie_detail["backdrop_path"],
                            :poster => movie_detail["poster_path"],
                            :file_size => size, :genres => genres, :imdb_id => imdb_id,
                            :magnetic_link => magnetic_link, :torrent_file_link => torrent_file_link,
                            :imdb_rating => rating)

  end
end
