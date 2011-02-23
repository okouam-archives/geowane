class CreateMap < ActiveRecord::Migration
  def self.up
    create_table :map do |t|
      t.integer  "end_level"
      t.integer  "level"
      t.boolean  "one_way"
      t.string   "label"
      t.integer  "type"
      t.geometry "shape", :limit => nil, :srid => 4326
    end
  end
  def self.down
  end
end
