class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :location_id
      t.integer :user_id
      t.string :label, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
