class Topology < ActiveRecord::Base
  belongs_to :location
  belongs_to :country
  belongs_to :region
  belongs_to :commune
  belongs_to :city
end
