class CreateCategoriesTable < ActiveRecord::Migration

 def up
    execute %{
      CREATE TABLE categories
      (
        id serial,
        french character varying(255),
        english character varying(255),
        is_hidden boolean NOT NULL default false,
        is_landmark boolean NOT NULL default false,
        classification_id integer REFERENCES classifications(id),
        created_at timestamp without time zone,
        updated_at timestamp without time zone,
        CONSTRAINT pk_categories PRIMARY KEY (id)
      );
      CREATE INDEX idx_categories_is_hidden ON categories(is_hidden);
      CREATE INDEX idx_categories_is_landmark ON categories(is_landmark);
      CREATE INDEX idx_categories_classification_id ON categories(classification_id);
    }
  end

  def down
    execute %{
      DROP TABLE categories;
    }
  end

end
