class CreateClassifications < ActiveRecord::Migration

  def self.up
    unless table_exists?(:classifications)
      create_table :classifications, :force => true do |t|
        t.timestamps
        t.string :french
        t.string :english
        t.string :icon
        t.string :code
        t.references :partner, :foreign_key => true, :dependent => :delete
      end
      add_index :classifications, ["partner_id"], :name => "idx_classifications_partner_id"
    end
  end

  def self.down
    drop_table :classifications if table_exists?(:classifications)
  end

end
