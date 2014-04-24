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

	def similar_movies(id, page=1)
		@params[:page] = page
		contents = fetch_url("movie/#{id}/similar_movies", @params)
		@params.delete(:page)
		
		JSON.parse(contents)
	end
end