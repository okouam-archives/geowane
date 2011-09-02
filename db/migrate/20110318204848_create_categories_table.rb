class CreateCategoriesTable < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :french, :limit => 200, :null => false
      t.string :english, :limit => 200, :null => false
      t.string :shape, :null => false
      t.string :code, :limit => 200
      t.string :icon, :limit => 200
      t.boolean :is_hidden, :default => false
      t.integer :numeric_code, :default => 0
      t.boolean :is_leaf, :default => true
      t.boolean :is_landmark, :default => false
      t.integer :tags_count
      t.timestamps
    end
  end
end
