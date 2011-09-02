class CreateTagsTable < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.references :location, :null => false, :foreign_key => true, :dependent => :delete
      t.references :category, :null => false, :foreign_key => true, :dependent => :delete
      t.timestamps
    end
    add_index "tags", ["location_id", "category_id", "id"], :name => "idx_tags_locations"
    add_index "tags", ["category_id", "location_id", "id"], :name => "idx_tags_categories"
  end
end
