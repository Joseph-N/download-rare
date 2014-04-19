namespace :fetch do
	desc "Fetches for dead links for movies and shows"	
	task :dead_movie_links =>  [:environment] do
		movie_count = Movie.where.not("download_link = ?","").count
		dead_links = 0

		Movie.where.not("download_link = ?","") .each do |movie|
			p "Scanning #{movie.title}"
			url = movie.download_link.gsub(/\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }

			begin
				# get headers
			    headers =  RestClient.head(url).headers 

			    #return content length header
			    size =  headers[:content_length]

			    #update movie
			    movie.update_attribute(:file_size, size)
			  rescue => e
			  	if e.response.code == 404 || e.response.code == 401 
			      	dead_links += 1
			      	DeadLink.where(resource_id: movie.id, resource_type: "movie").first_or_create!;
			      	p "#{movie.title}(id: #{movie.id}) has a dead link"
			    end
			  end
			end

			message =  "Scanned: #{movie_count} movies, Found: #{dead_links} dead links"
			NotifierWorker.perform_async(message)
		end

		task :dead_tv_links =>  [:environment] do
			episode_count = DownloadLink.count
			dead_links = 0

			DownloadLink.find_each do |link|
				p "Scanning #{link.episode.season.tv_show.name} S0#{link.episode.season.season_number}E#{link.episode.episode_number}"
				# escape url
				url = link.url.gsub(/\{|\}|\||\\|\^|\[|\]|`|\s+/) { |m| CGI::escape(m) }

				# get headers
				begin
					headers =  RestClient.head(url).headers 

					#return content length header
					size =  headers[:content_length]

					#update episode
					link.update_attribute(:file_size, size)
				      
				rescue => e
					if e.response.code == 404 || e.response.code == 401 
						dead_links +=1
						DeadLink.where(resource_id: link.episode.id, resource_type: "episode").first_or_create!
						p "Episode(id: #{link.episode.id}) of #{link.episode.season.tv_show.name} S0#{link.episode.season.season_number}E#{link.episode.episode_number} has a dead link"		        
					end  
				end
			end
			message = "Scanned: #{episode_count} episodes Found: #{dead_links} dead links"
			NotifierWorker.perform_async(message) 
		end

	task :all_broken => [:dead_movie_links, :dead_tv_links]
end