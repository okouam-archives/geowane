class AddIndexesForTags < ActiveRecord::Migration
  def self.up
    add_index "tags", ["location_id", "category_id", "id"], :name => "idx_tags_locations"
    add_index "tags", ["category_id", "location_id", "id"], :name => "idx_tags_categories"
  end

  def self.down
  end
end
