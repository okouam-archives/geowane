class CreatePhotos < ActiveRecord::Migration

  def up
    execute %{
      CREATE TABLE photos
      (
        id serial,
        location_id integer REFERENCES locations(id)
        image character varying(255),
        created_at timestamp without time zone,
        updated_at timestamp without time zone,
        CONSTRAINT pk_photos PRIMARY KEY (id)
      );
    }
  end

  def down
    execute %{
      DROP TABLE photos;
    }
  end

end
