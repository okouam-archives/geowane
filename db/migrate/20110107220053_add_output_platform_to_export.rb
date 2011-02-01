class AddOutputPlatformToExport < ActiveRecord::Migration
  def self.up
    add_column :exports, :output_platform, :string
  end

  def self.down
  end
end
