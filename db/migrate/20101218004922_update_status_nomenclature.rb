class UpdateStatusNomenclature < ActiveRecord::Migration
  def self.up
    execute %{
      UPDATE locations SET status = 'new' WHERE status = 'NEW';
      UPDATE locations SET status = 'invalid' WHERE status = 'INVALID';
      UPDATE locations SET status = 'corrected' WHERE status = 'CORRECTED';
      UPDATE locations SET status = 'audited' WHERE status = 'AUDITED';
      UPDATE locations SET status = 'field_checked' WHERE status = 'FIELD CHECKED';
    }
  end

  def self.down
  end
end
