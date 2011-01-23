class UpdateTopologies < ActiveRecord::Migration

  def self.up
    add_column :topologies, :level0, :string
    add_column :topologies, :level1, :string
    add_column :topologies, :level2, :string
    add_column :topologies, :level3, :string
    add_column :topologies, :level4, :string
    add_column :topologies, :level0_name, :string
    add_column :topologies, :level1_name, :string
    add_column :topologies, :level2_name, :string
    add_column :topologies, :level3_name, :string
    add_column :topologies, :level4_name, :string
  end

  def self.down
  end

end
