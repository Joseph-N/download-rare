namespace :fetch do
	desc "Fetches for dead links for movies and shows"	
	task :dead_movie_links =>  [:environment] do
		movie_count = Movie.all.count
		dead_links = 0

		Movie.where.not("download_link = ?","") .each do |movie|
	      url = movie.download_link.gsub(/\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }

	      begin
	      	# get headers
		    headers =  RestClient.head(url).headers 

		    #return content length header
		    size =  headers[:content_length]

		    #update movie
		    movie.update_attribute(:file_size, size)
	      rescue
	      	dead_links += 1
	      	DeadLink.where(resource_id: movie.id, resource_type: "movie").first_or_create!;
	      	p "#{movie.title}(id: #{movie.id}) has a dead link"	      	
	      end
	    end

	    p "Scanned: #{movie_count} movies"
	    p "Found: #{dead_links} dead links"
	    p "*"*100
	end

	task :dead_tv_links =>  [:environment] do
		episode_count = Episode.where.not("download_link is ?", nil).count
		dead_links = 0

		Episode.where.not("download_link is ?", nil).each do |episode|
			# escape url
			url = episode.download_link.gsub(/\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }

			# get headers
			begin
				headers =  RestClient.head(url).headers 

				#return content length header
				size =  headers[:content_length]

				#update episode
				episode.update_attribute(:file_size, size)
			      
			rescue
				dead_links +=1
				DeadLink.where(resource_id: episode.id, resource_type: "episode").first_or_create!;
				p "Episode(id: #{episode.id}) of #{episode.season.tv_show.name} S0#{episode.season.season_number}E#{episode.episode_number} has a dead link"

			end  
		end
		p "Scanned: #{episode_count} episodes"
		p "Found: #{dead_links} dead links"  
	end

	task :all_broken => [:dead_movie_links, :dead_tv_links]
end