class UpdateNumericCodeForCategories < ActiveRecord::Migration
  def self.up
    execute %{
      update categories set numeric_code = to_dec(substring(code from 3))
    }
  end

  def self.down
  end
end
