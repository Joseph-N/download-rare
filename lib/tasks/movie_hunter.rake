namespace :movies do
	desc "Fetches for movies from YTS and adds them to the database"
	task :hunt => [:environment] do
		# base url
		BASE_URL = "http://yts.re/api/list.json"

		# method to fetch contents from yts
		def call_yts_api(count)
	  		raw_data = RestClient.get BASE_URL, 
			{ :params => 
				{ :quality => '720p',
				  :set => count,
				  :limit => 50,
				  :rating => 1,
				  :sort => "date",
				  :order => "desc" 
				} 
			}
			JSON.parse(raw_data)
	  	end

		# very big set just in case
		sets = (0..100000).to_a

  		sets.each do |set|
  			contents = call_yts_api(set+=1)
  			# see if we reached end point
  			unless contents["status"].eql?("fail")
  				contents["MovieList"].each do |movie|
  					p "Sending #{movie["MovieTitle"]} to save queue"
  					YtsWorker.perform_in(2.minutes, movie["ImdbCode"])
  				end
  			else
  				p "All done!"
  				break
  			end
  		end
	end
end