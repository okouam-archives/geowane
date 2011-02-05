class CreateTags < ActiveRecord::Migration

  def self.up
    create_table :tags, :force => true do |t|
      t.references :location
      t.references :category
      t.timestamps
    end
    add_index "tags", ["location_id", "category_id", "id"], :name => "idx_tags_locations"
    add_index "tags", ["category_id", "location_id", "id"], :name => "idx_tags_categories"
  end

  def self.down
    drop_table :tags
  end

end
