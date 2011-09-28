class CreateLogos < ActiveRecord::Migration

  def up
    execute %{
      CREATE TABLE logos
      (
        id serial,
        location_id integer REFERENCES locations(id)
        image character varying(255),
        created_at timestamp without time zone,
        updated_at timestamp without time zone,
        CONSTRAINT pk_logos PRIMARY KEY (id)
      );
    }
  end

  def down
    execute %{
      DROP TABLE logos;
    }
  end

end

