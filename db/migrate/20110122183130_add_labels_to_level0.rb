class AddLabelsToLevel0 < ActiveRecord::Migration
  def self.up
    add_column :level0, :level1_type, :string
    add_column :level0, :level2_type, :string
    add_column :level0, :level3_type, :string
    add_column :level0, :level4_type, :string

    execute %{
      UPDATE level0
        SET level1_type = 'Région', level2_type = 'Département', level3_type = 'Arrondissement'
      WHERE name = 'Sénégal';
      UPDATE level0
        SET level1_type = 'Département', level2_type = 'Commune'
      WHERE name = 'Bénin';
      UPDATE level0
        SET level1_type = 'Région', level2_type = 'Préfecture', level3_type = 'Sous-Préfecture'
      WHERE name = 'Guinée-Conakry';
      UPDATE level0
        SET level1_type = 'Région', level2_type = 'Département', level3_type = 'Sous-Préfecture', level4_type = 'Commune'
      WHERE name = 'Côte d'Ivoire';
      UPDATE level0
        SET level1_type = 'Région', level2_type = 'Préfecture', level3_type = 'Commune'
      WHERE name = 'Togo';
    }
  end

  def self.down
  end
end
