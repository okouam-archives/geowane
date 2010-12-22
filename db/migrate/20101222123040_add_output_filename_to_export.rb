class AddOutputFilenameToExport < ActiveRecord::Migration
  def self.up
    add_column :exports, :name, :string
  end

  def self.down
  end
end
