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