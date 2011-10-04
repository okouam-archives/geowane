class Change < ActiveRecord::Base
  belongs_to :changeset
  set_table_name "model_changes"

end