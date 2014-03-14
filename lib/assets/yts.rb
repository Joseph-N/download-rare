class Yts
	require "json"
	require "rest-client"

	BASE_API_URL = "http://yts.re/api/list.json"

	def find(imdb_id)
		unless $redis.exists hash("yts-#{imdb_id}")
			contents = RestClient.get BASE_API_URL, { :params => { :keywords => imdb_id, :quality => '720p'} }
			# save to redis
			unless JSON.parse(contents)["status"] == "fail"
			        $redis.set(hash("yts-#{imdb_id}"), contents)
			        $redis.expire(hash("yts-#{imdb_id}"), 86400)
			end
		else
			contents = $redis.get(hash("yts-#{imdb_id}"))
		end
		JSON.parse(contents)		
	end

	private
		def hash(key)
			Digest::MD5.hexdigest(key.to_s)
		end
end
