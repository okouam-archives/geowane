class Classification < ActiveRecord::Base
  validates_presence_of :french, :english
  has_many :categories, :through => :mappings
  has_many :mappings
  belongs_to :partner

end