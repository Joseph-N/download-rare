class TvWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :tv, :retry => 3, :backtrace => true
  
  def perform(tv_show_id)
  	# new TmdbTv instance
  	@tv = TmdbTv.new("29588c40b1a3ef6254fd1b6c86fbb9a9")

  	# fetch tv show
  	@record = TvShow.find(tv_show_id) 

  	# fetch show from tmdb
  	@show = @tv.find(@record.tmdb_id)

  	# update record
  	@record.update_attributes(number_of_episodes: @show["number_of_episodes"],
  						     number_of_seasons: @show["number_of_seasons"]
  						    )

  	# create seasons
  	@show["seasons"].each do |season|
  		unless((season["season_number"].eql? 0) || (season["season_number"].nil?))
  			@record.seasons.create!(season_number: season["season_number"])
  		end  
  	end

  	# save seasons
  	@record.seasons.each do |season|
  		# fetch season from api
  		@season_info = @tv.find_season(@record.tmdb_id, season.season_number)

  		#create episodes
  		@season_info["episodes"].each do |episode|
  			season.episodes.create!(episode_number: episode["episode_number"] )
  		end
  	end

  end
end