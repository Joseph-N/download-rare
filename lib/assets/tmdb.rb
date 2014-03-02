class Tmdb

	require "json"
	require "rest-client"

	BASE_API_URL = "http://api.themoviedb.org/3"

	@@config = ""

	def initialize(api_key)
		@api_key = api_key 
		@params = { :api_key => @api_key }
		if @@config.empty?
			set_config
		end
	end

	def image_url(type, size, file_path)
		config = JSON.parse(@@config)
		base_url = config['images']['base_url']
		if config['images'][type + '_sizes'].include?(size)
			begin
				base_url + size + file_path
			rescue
				''
			end
		end
	end


	private
		def set_config
			@@config = fetch_url('configuration', @params) 
		end

		def fetch_url(path, params)
			RestClient.get BASE_API_URL + "/#{path}", { :params => params }
		end
end

class TmdbMovie < Tmdb
	def find(id)
		@params[:append_to_response] = "trailers,images"
		contents = fetch_url("movie/#{id}",@params)
		# we don't need this anymore
		@params.delete(:append_to_response)

		JSON.parse(contents)
	end

	def search(title)
		@params[:query] = title
		contents = fetch_url("search/movie", @params)
		# we don't need this anymore
		@params.delete(:query)

		JSON.parse(contents)
	end
end

class TmdbTv < Tmdb
	def find(id)
		@params[:append_to_response] = "images"
		contents = fetch_url("tv/#{id}", @params)
		JSON.parse(contents)
	end

	def search(title)
		@params["query"] = title
		contents =  fetch_url("search/tv", @params)
		# we don't need this anymore
		@params.delete(:query)

		JSON.parse(contents)
	end

	def find_season(tv_id, season_number)
		contents = fetch_url("tv/#{tv_id}/season/#{season_number}", @params)
		JSON.parse(contents)
	end
end
