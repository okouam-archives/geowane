class Category < ActiveRecord::Base
  has_many :locations
  validates_presence_of :french, :english

  def json_object
    {:name => self.french, :icon => self.icon, :id => self.id}
  end

  def bilingual_name
    "#{self.french} / #{self.english}"
  end

end