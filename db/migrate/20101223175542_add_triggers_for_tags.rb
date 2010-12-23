class AddTriggersForTags < ActiveRecord::Migration
  def self.up
    execute %(
    CREATE OR REPLACE FUNCTION tag_change() RETURNS trigger AS '
        DECLARE
        BEGIN
          IF tg_op = ''DELETE'' THEN
	     UPDATE categories SET tags_count = (SELECT COUNT(*) FROM tags WHERE category_id = OLD.category_id)
	     WHERE id = OLD.category_id;
	     UPDATE locations SET tags_count = (SELECT COUNT(*) FROM tags WHERE location_id = OLD.location_id)
	     WHERE id = OLD.location_id;
             RETURN OLD;
          END IF;
          IF tg_op = ''INSERT'' THEN
	     UPDATE categories SET tags_count = (SELECT COUNT(*) FROM tags WHERE category_id = NEW.category_id)
	     WHERE id = NEW.category_id;
	     UPDATE locations SET tags_count = (SELECT COUNT(*) FROM tags WHERE location_id = NEW.location_id)
	     WHERE id = NEW.location_id;
          END IF;
          RETURN NEW;
        END
        ' LANGUAGE plpgsql;
  
    CREATE TRIGGER tag_change AFTER INSERT OR DELETE ON tags
    FOR EACH ROW EXECUTE PROCEDURE tag_change(); 
    )
  end

  def self.down
    execute %{
      DROP TRIGGER tag_change ON tags;
      DROP FUNCTION tag_change();
    }
  end
end
