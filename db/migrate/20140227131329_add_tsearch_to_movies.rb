class AddTsearchToMovies < ActiveRecord::Migration
 def self.up
    execute(<<-'eosql'.strip)
      ALTER TABLE movies ADD COLUMN tsv tsvector;

      CREATE FUNCTION movies_generate_tsvector() RETURNS trigger AS $$
        begin
          new.tsv :=
            setweight(to_tsvector('pg_catalog.english', coalesce(new.title,'')), 'A');
          return new;
        end
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER tsvector_movies_upsert_trigger BEFORE INSERT OR UPDATE
        ON movies
        FOR EACH ROW EXECUTE PROCEDURE movies_generate_tsvector();

      UPDATE movies SET tsv =
        setweight(to_tsvector('pg_catalog.english', coalesce(title,'')), 'A');

      CREATE INDEX movies_tsv_idx ON movies USING gin(tsv);
    eosql
  end

  def self.down
    execute(<<-'eosql'.strip)
      DROP INDEX IF EXISTS movies_tsv_idx;
      DROP TRIGGER IF EXISTS tsvector_movies_upsert_trigger ON movies;
      DROP FUNCTION IF EXISTS movies_generate_tsvector();
      ALTER TABLE movies DROP COLUMN tsv;
    eosql
  end
end
