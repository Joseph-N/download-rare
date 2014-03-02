class TvShow < ActiveRecord::Base
	extend FriendlyId
  	friendly_id :name, use: :slugged

	validates_uniqueness_of :tmdb_id

	default_scope { order('created_at DESC') } 

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
end
