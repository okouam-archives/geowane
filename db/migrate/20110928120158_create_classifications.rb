class CreateClassifications < ActiveRecord::Migration

  def up
    execute %{
      CREATE TABLE classifications
      (
        id serial,
        name character varying(255),
        created_at timestamp without time zone,
        updated_at timestamp without time zone,
        CONSTRAINT pk_classifications PRIMARY KEY (id)
      );
    }
  end

  def down
    execute %{
      DROP TABLE classifications;
    }
  end

end
