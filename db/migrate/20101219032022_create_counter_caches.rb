class CreateCounterCaches < ActiveRecord::Migration

  def self.up

    add_column :categories, :tags_count, :integer, :default => 0

    execute %{
      update categories set tags_count = x.total 
      from 
      (select categories.id, count(*) as total
      from categories 
      JOIN tags on tags.category_id = categories.id
      GROUP BY categories.id) x 
      WHERE x.id = categories.id
    }
    Location.reset_column_information

    add_column :locations, :tags_count, :integer, :default => 0

    execute %{
      update locations set tags_count = x.total 
      from 
      (select locations.id, count(*) as total
      from locations 
      JOIN tags on tags.location_id = locations.id
      GROUP BY locations.id) x 
      WHERE x.id = locations.id
    }

    Category.reset_column_information
    
  end

  def self.down
    remove_column :locations, :tags_count
    remove_column :categories, :tags_count
  end
end
