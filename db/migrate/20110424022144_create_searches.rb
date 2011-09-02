class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches, :force => true do |t|
      t.text :sql
      t.integer :page
      t.integer :per_page
      t.string :persistence_token
      t.references :user, :foreign_key => true
      t.timestamps
    end
    add_index :searches, [:persistence_token], :name => 'idx_searches_persistence_token'
  end
end
