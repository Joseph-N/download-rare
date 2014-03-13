class Movie < ActiveRecord::Base
	extend FriendlyId
  	friendly_id :title, use: :slugged

  	after_save :load_into_soulmate
  	before_destroy :remove_from_soulmate

	validates_uniqueness_of :tmdb_id
	validates_presence_of :download_link

	default_scope { order('created_at DESC') } 

	# Note that ActiveRecord ARel from() doesn't appear to accommodate "?"
	# param placeholder, hence the need for manual parameter sanitization
	def self.tsearch_query(search_terms, limit = query_limit)
		words = sanitize(search_terms.scan(/\w+/) * "|")

		Movie.from("movies, to_tsquery('pg_catalog.english', #{words}) as q").
		  where("tsv @@ q").order("ts_rank_cd(tsv, q) DESC").limit(limit)
	end

	# Selects search results with plain text title & body columns.
  	# Select columns are explicitly listed to avoid returning the long redundant tsv strings
  	def self.plain_tsearch(search_terms, limit = query_limit)
    	select([:title, :poster, :release_date, :tmdb_id, :slug, :download_link, :id]).tsearch_query(search_terms, limit)
  	end

	def self.query_limit; 25; end

	def self.search(title)
    	all = Soulmate::Matcher.new("shows-and-movies").matches_for_term(title)
    	all.collect { |c| { "id" => c["id"], "name" => c["term"], "permalink" => c["data"]["permalink"], "image" => c["data"]["image"], "type" => c["data"]["type"] } }
  	end

	private

	def load_into_soulmate
		loader = Soulmate::Loader.new("shows-and-movies")
	   	loader.add("term" => title, "id" => self.id, "data" => {
	   			"permalink" => Rails.application.routes.url_helpers.movie_path(self),
	   			"image" => "http://image.tmdb.org/t/p/w45#{poster}",
	   			"type" => "movie"
	   	})
	end

	def remove_from_soulmate
	    loader = Soulmate::Loader.new("shows-and-movies")
	    loader.remove("id" => self.id)
	end
end
