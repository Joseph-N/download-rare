class Search < ActiveRecord::Base
	def movies
		@movies ||= find_movies
	end

	private

	def find_movies
	  Movie.where(conditions)
	end

	def keyword_conditions
	  ["movies.title iLIKE ?", "%#{title}%"] unless title.blank?
	end

	def year_conditions
	  ["movies.release_date >= ? and movies.release_date <= ?", "#{year}-01-01", "#{year}-12-31"] unless year.blank?
	end

	def genre_conditions
	  ["? = ANY (genres)", genre] unless genre.blank?
	end

	def rating_conditions
	  ["movies.imdb_rating >= ?", rating] unless rating.blank?
	end

	def conditions
	  [conditions_clauses.join(' AND '), *conditions_options]
	end

	def conditions_clauses
	  conditions_parts.map { |condition| condition.first }
	end

	def conditions_options
	  conditions_parts.map { |condition| condition[1..-1] }.flatten
	end

	def conditions_parts
	  private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
	end
end
