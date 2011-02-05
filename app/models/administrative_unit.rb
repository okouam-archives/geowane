class AdministrativeUnit < ActiveRecord::Base
  validates_presence_of :name, :type
end