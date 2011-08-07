class Mapping < ActiveRecord::Base
  belongs_to :category
  belongs_to :classification
end