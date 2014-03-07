namespace :shows do
	desc "update tv shows"	
	task :update =>  [:environment] do
		require 'tmdb'

		# new TmdbTv instance
	  	@tv = TmdbTv.new("29588c40b1a3ef6254fd1b6c86fbb9a9")

		def remove_key_from_redis(key)
			# delete redis key for show
	  		$redis.del @tv.hash(key)
		end

	  	TvShow.all.each do |show|

	  		p "Updating #{show.name}..."

	  		if remove_key_from_redis(show.tmdb_id).eql? 1
	  			p "Successfully removed redis key for #{show.name}"
	  		else
	  			p "No key for #{show.name}"
	  		end

		  	# fetch show from tmdb
		  	@show = @tv.find(show.tmdb_id)

		  	# update record
		  	show.update_attributes(number_of_episodes: @show["number_of_episodes"],
		  						     number_of_seasons: @show["number_of_seasons"]
		  						    )

		  	p "  --> updated number of seasons and episodes of #{show.name}...."

		  	# update seasons
		  	@show["seasons"].each do |season|
		  		unless((season["season_number"].eql? 0) || (season["season_number"].nil?))
		  			show.seasons.where(:season_number => season["season_number"]).first_or_create
		  		end  
		  	end

		  	p "  --> updated seasons of #{show.name}"

		  	# update season episodes
		  	show.seasons.each do |season|

		  		if remove_key_from_redis("#{season.tv_show.tmdb_id}_#{season.season_number}").eql? 1
		  			p "     > Successfully removed redis key for #{season.tv_show.name} season #{season.season_number}"
		  		else
		  			p "     > No key for #{season.tv_show.name} season #{season.season_number}"
		  		end

		  		# fetch season from api
		  		@season_info = @tv.find_season(season.tv_show.tmdb_id, season.season_number)

		  		#update episodes
		  		@season_info["episodes"].each do |episode|
		  			season.episodes.where(episode_number: episode["episode_number"]).first_or_create
		  		end
		  		p "       > Successfully updated episodes list of #{season.tv_show.name}"
		  	end

		  	p "=" * 100
	  	end

	end
end
