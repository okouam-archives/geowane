class AddMoreInfoToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :mobile_number, :string
    add_column :users, :skype_alias, :string
    add_column :users, :home_country, :string
  end

  def self.down
  end
end
