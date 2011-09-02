class CreatePartnersTable < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.timestamps
      t.string :name
    end
  end
end
