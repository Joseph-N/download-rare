class TvShow < ActiveRecord::Base
	extend FriendlyId
  	friendly_id :name, use: :slugged

   	after_save :load_into_soulmate
  	before_destroy :remove_from_soulmate

	validates_uniqueness_of :tmdb_id

	default_scope { order('updated_at DESC') } 

	has_many :seasons, dependent: :destroy

	# Note that ActiveRecord ARel from() doesn't appear to accommodate "?"
	# param placeholder, hence the need for manual parameter sanitization
	def self.tsearch_query(search_terms, limit = query_limit)
		words = sanitize(search_terms.scan(/\w+/) * "|")

		TvShow.from("tv_shows, to_tsquery('pg_catalog.english', #{words}) as q").
		  where("tsv @@ q").order("ts_rank_cd(tsv, q) DESC").limit(limit)
	end

	# Selects search results with plain text title & body columns.
  	# Select columns are explicitly listed to avoid returning the long redundant tsv strings
  	def self.plain_tsearch(search_terms, limit = query_limit)
    	select([:name, :poster, :release_date, :tmdb_id, :slug]).tsearch_query(search_terms, limit)
  	end

	def self.query_limit; 25; end

	private

	def load_into_soulmate
		loader = Soulmate::Loader.new("shows")
	   	loader.add("term" => name, "id" => self.id, "data" => {
	   			"permalink" => Rails.application.routes.url_helpers.tv_show_path(self),
	   			"image" => "http://image.tmdb.org/t/p/w45#{poster}"
	   	})
	end

	def remove_from_soulmate
	    loader = Soulmate::Loader.new("shows")
	    loader.remove("id" => self.id)
	end
end
