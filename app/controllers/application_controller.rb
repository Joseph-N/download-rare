class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :init_movies, :init_shows


  require 'tmdb'

  def init_movies
  	@tmdb = Tmdb.new("29588c40b1a3ef6254fd1b6c86fbb9a9")
    @tmdb_movie = TmdbMovie.new("29588c40b1a3ef6254fd1b6c86fbb9a9")
  end 

  def init_shows
    @tmdb_tv = TmdbTv.new("29588c40b1a3ef6254fd1b6c86fbb9a9")
  end 
end
