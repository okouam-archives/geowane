class CreateRules < ActiveRecord::Migration
  def up
    execute %{
      CREATE TABLE rules
      (
        id integer,
        french character varying(255),
        english character varying(255),
        category_id integer REFERENCES categories(id),
        ruleset_id integer REFERENCES rulesets(id),
        created_at timestamp without time zone,
        updated_at timestamp without time zone,
        CONSTRAINT pkey_rules PRIMARY KEY (id)
      );
      CREATE INDEX idx_rules_category_id ON rulesets(category_id);
      CREATE INDEX idx_rules_ruleset_id ON rulesets(ruleset_id);
    }
  end

  def down
    execute %{
      DROP TABLE rules;
    }
  end

end
