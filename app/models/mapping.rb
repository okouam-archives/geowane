class Mapping < ActiveRecord::Base
  validates_presence_of :french, :english
  belongs_to :category
  belongs_to :partner
end