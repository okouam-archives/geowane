class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags, :force => true do |t|
      t.references :location
      t.references :category
      t.timestamps
    end
  end

  def self.down
  end
end
