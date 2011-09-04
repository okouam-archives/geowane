class Mapping < ActiveRecord::Base
  belongs_to :category
  belongs_to :partner_category
end