class CreateLogos < ActiveRecord::Migration

  def up
    create_table :logos do |t|
      t.string :image
      t.timestamps
      t.references :location
    end
  end

  def down
  end
end

