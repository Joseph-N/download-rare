class AddTsearchToTvShows < ActiveRecord::Migration
	def self.up
	    execute(<<-'eosql'.strip)
	      ALTER TABLE tv_shows ADD COLUMN tsv tsvector;

	      CREATE FUNCTION tv_shows_generate_tsvector() RETURNS trigger AS $$
	        begin
	          new.tsv :=
	            setweight(to_tsvector('pg_catalog.english', coalesce(new.name,'')), 'A');
	          return new;
	        end
	      $$ LANGUAGE plpgsql;

	      CREATE TRIGGER tsvector_tv_shows_upsert_trigger BEFORE INSERT OR UPDATE
	        ON tv_shows
	        FOR EACH ROW EXECUTE PROCEDURE tv_shows_generate_tsvector();

	      UPDATE tv_shows SET tsv =
	        setweight(to_tsvector('pg_catalog.english', coalesce(name,'')), 'A');

	      CREATE INDEX tv_shows_tsv_idx ON tv_shows USING gin(tsv);
	    eosql
  	end

	def self.down
	    execute(<<-'eosql'.strip)
	      DROP INDEX IF EXISTS tv_shows_tsv_idx;
	      DROP TRIGGER IF EXISTS tsvector_tv_shows_upsert_trigger ON tv_shows;
	      DROP FUNCTION IF EXISTS tv_shows_generate_tsvector();
	      ALTER TABLE tv_shows DROP COLUMN tsv;
	    eosql
	end
end
