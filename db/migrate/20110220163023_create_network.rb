class CreateNetwork < ActiveRecord::Migration
  def self.up
    create_table :map do |t|
      t.decimal :x1
      t.decimal :y1
      t.decimal :x2
      t.decimal :y2
      t.integer :source
      t.integer :target
      t.decimal :cost
      t.geometry :shape,:limit => nil, :srid => 4326
      t.decimal :reverse_cost
    end
  end

  def self.down
  end
end
