class Yts
	require "json"
	require "rest-client"

	BASE_API_URL = "http://yts.re/api/list.json"

	def find(imdb_id)
		unless $redis.exists hash(imdb_id)
			contents = RestClient.get BASE_API_URL, { :params => { :keywords => imdb_id, :quality => '720p'} }
			# save to redis
			$redis.set(hash(imdb_id), contents)
			$redis.expire(hash(imdb_id), 86400)
		else
			contents = $redis.get(hash(imdb_id))
		end
		JSON.parse(contents)		
	end

	private
		def hash(key)
			Digest::MD5.hexdigest(key.to_s)
		end
end
