class CreateRulesets < ActiveRecord::Migration
  def up
    execute %{
      CREATE TABLE rulesets
      (
        id integer,
        name character varying(255),
        created_at timestamp without time zone,
        updated_at timestamp without time zone,
        CONSTRAINT pkey_rulesets PRIMARY KEY (id)
      );
    }
  end

  def down
    execute %{
      DROP TABLE rulesets;
    }
  end

end
