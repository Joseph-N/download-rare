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

class TmdbMovie < Tmdb
	def find(id)
		@params[:append_to_response] = "trailers,images"

		unless $redis.exists hash(id)
			contents = fetch_url("movie/#{id}",@params)
			# save to redis
			$redis.set(hash(id), contents)
			$redis.expire(hash(id), 86400)
		else
			contents = $redis.get(hash(id))
		end

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

	def search_by_imdb_id(imdb_id)
		@params[:external_source] = "imdb_id"
		contents = fetch_url("find/#{imdb_id}", @params)
		@params.delete(:external_source)

		JSON.parse(contents)
	end
end

class TmdbTv < Tmdb
	def find(id)
		@params[:append_to_response] = "images"
		unless $redis.exists hash(id)			
			contents = fetch_url("tv/#{id}", @params)
			# save to redis
			$redis.set(hash(id), contents)
			$redis.expire(hash(id), 86400)
		else
			contents = $redis.get(hash(id))
		end
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
		key = "#{tv_id}_#{season_number}"

		unless $redis.exists hash(key)
			contents = fetch_url("tv/#{tv_id}/season/#{season_number}", @params)
			$redis.set(hash(key), contents)
			$redis.expire(hash(key), 86400)
		else
			contents = $redis.get(hash(key))
		end
		JSON.parse(contents)
	end
end
