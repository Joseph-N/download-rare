class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :init_tmdb, :deadlinks


  def init_tmdb
  	@tmdb = Tmdb.new("29588c40b1a3ef6254fd1b6c86fbb9a9")
    @tmdb_movie = TmdbMovie.new("29588c40b1a3ef6254fd1b6c86fbb9a9")
    @tmdb_tv = TmdbTv.new("29588c40b1a3ef6254fd1b6c86fbb9a9")
    @yts = YtsTorrents.new
  end 

  def randomize(key)
    Digest::MD5.hexdigest(key.to_s)
  end

  def deadlinks
    @deadlinks = DeadLink.all
  end

  def fetch_genres
    genres = []
    Movie.all.each do |movie|
        genres << movie.genres
    end
    genres
  end
end
