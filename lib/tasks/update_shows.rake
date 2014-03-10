namespace :shows do
	desc "update tv shows"	
	task :update =>  [:environment] do
		require 'tmdb'

		# new TmdbTv instance
	  	@tv = TmdbTv.new("29588c40b1a3ef6254fd1b6c86fbb9a9")

		def remove_key_from_redis(key)
	  		$redis.del @tv.hash(key)
		end

		p "*****************************************************"
		p "*     #{Time.now.strftime('%a %m %Y at %I:%M%p')}" + " "*24 + "*"
		p "*****************************************************"
		p ""

	  	TvShow.all.each do |show|

	  		p " Updating #{show.name}"

	  		if remove_key_from_redis(show.tmdb_id).eql? 1
	  			p "Remove redis key for show................................OK"
	  		else
	  			p "No key for #{show.name}"
	  		end

		  	# fetch show from tmdb
		  	@show = @tv.find(show.tmdb_id)

		  	# update record
		  	show.update_attributes(number_of_episodes: @show["number_of_episodes"],
		  						     number_of_seasons: @show["number_of_seasons"]
		  						    )

		  	p "  --> Update seasons and episodes count..................OK"

		  	# update seasons
		  	@show["seasons"].each do |season|
		  		unless((season["season_number"].eql? 0) || (season["season_number"].nil?))
		  			show.seasons.where(:season_number => season["season_number"]).first_or_create
		  		end  
		  	end

		  	p "  --> Update seasons.....................................OK"

		  	# update season episodes
		  	show.seasons.each do |season|

		  		if remove_key_from_redis("#{season.tv_show.tmdb_id}_#{season.season_number}").eql? 1
		  			p "     > Remove redis key for S0#{season.season_number}..........................OK"
		  		else
		  			p "     > No key for #{season.tv_show.name} season #{season.season_number}"
		  		end

		  		# fetch season from api
		  		@season_info = @tv.find_season(season.tv_show.tmdb_id, season.season_number)

		  		#update episodes
		  		@season_info["episodes"].each do |episode|
		  			season.episodes.where(episode_number: episode["episode_number"]).first_or_create
		  		end
		  		p "       > Update episode list.............................OK"
		  	end

		  	p "*" * 59
	  	end

	end
end
