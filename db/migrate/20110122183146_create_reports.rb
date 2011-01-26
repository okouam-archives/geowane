class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.string :sql, :null => false
      t.string :name, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end
end
