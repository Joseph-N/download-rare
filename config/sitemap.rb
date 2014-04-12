# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://downloadrare.com"

SitemapGenerator::Sitemap.create do
  # Add movies
  add movies_path, :priority => 0.7, :changefreq => 'weekly'

  # Add all movies
  Movie.find_each do |movie|
    add movie_path(movie), :lastmod => movie.updated_at
  end

  # Add TvShows
  add tv_shows_path, :priority => 0.6, :changefreq => 'weekly'

  # All TvShows
  TvShow.find_each do |show|
    add tv_show_path(show), :lastmod => show.updated_at, :changefreq => 'daily'

    # add seasons
    show.seasons.each do |season|
      add tv_show_season_path(show, season), :changefreq => 'daily', :lastmod => season.updated_at
    end
  end



  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
