class Tmdb

	require "json"
	require "rest-client"

	BASE_API_URL = "http://api.themoviedb.org/3"

	@@config = $redis.get("tmdb_config")

	def initialize(api_key)
		@api_key = api_key 
		@params = { :api_key => @api_key }
		if @@config.nil?
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

	def hash(key)
		Digest::MD5.hexdigest(key.to_s)
	end


	private
		def set_config
			@@config = fetch_url('configuration', @params) 
			$redis.set("tmdb_config", @@config)
		end

		def fetch_url(path, params)
			RestClient.get BASE_API_URL + "/#{path}", { :params => params }
		end
end
