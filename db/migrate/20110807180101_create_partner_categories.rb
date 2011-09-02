class CreatePartnerCategories < ActiveRecord::Migration
   def change
    create_table :partner_categories, :force => true do |t|
      t.timestamps
      t.string :french
      t.string :english
      t.string :icon
      t.string :code
      t.references :partner, :foreign_key => true, :dependent => :delete
    end
    add_index :partner_categories, ["partner_id"], :name => "idx_partner_categories_partner_id"
  end
end
