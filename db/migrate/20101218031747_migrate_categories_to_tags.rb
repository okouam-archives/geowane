class MigrateCategoriesToTags < ActiveRecord::Migration
  def self.up
    execute %{
      INSERT INTO tags(category_id, location_id) SELECT category_id, id 
      FROM locations WHERE category_id IN (SELECT id FROM categories)
    }
  end

  def self.down
  end
end
