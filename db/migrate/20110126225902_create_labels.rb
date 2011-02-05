class CreateLabels < ActiveRecord::Migration

  def self.up
    create_table :labels do |t|
      t.string :key, :null => false
      t.string :value, :null => false
      t.string :classification
      t.references :location
      t.timestamps
    end
  end

  def self.down
    drop_table :labels
  end
  
end

