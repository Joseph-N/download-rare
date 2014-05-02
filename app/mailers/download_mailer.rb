class DownloadMailer < ActionMailer::Base
  	default from: "downloads@downloadrare.com"

	def notify(resource_type, resource, download_type)
	    if resource_type == "movie"
	    	@movie = resource
	    	@episode = nil
	    	subject = "New Download: #{@movie.title}"
	    elsif resource_type == "episode"
	    	@episode = resource
	    	@movie = nil
	    	subject = "New Download: #{@episode.season.tv_show.name}  S0#{@episode.season.season_number}E#{@episode.episode_number}"
	    end
	    @download_type = download_type
	    mail(to: "admin@downloadrare.com", subject: subject)
	end
end
