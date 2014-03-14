class MovieWorker
  include Sidekiq::Worker
  
  def perform(movie_id)
  	# fetch the move
  	movie = Movie.find(movie_id)

  	# escape url
  	url = movie.download_link.gsub(/\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }

  	# get headers
	headers =  RestClient.head(url).headers 

  	#return content length header
  	size =  headers[:content_length]

  	#update movie
  	movie.update_attribute(:file_size, size)

  end
end
