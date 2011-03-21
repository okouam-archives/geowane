class CreatePartnersTable < ActiveRecord::Migration

  def self.up
    unless table_exists?(:partners)
      create_table :partners, :force => true do |t|
        t.timestamps
        t.string :name
      end
    end
  end

  def self.down
    drop_table :partners if table_exists?(:partners)
  end

end
