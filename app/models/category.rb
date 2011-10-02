class Category < ActiveRecord::Base
  has_many :locations, :through => :tags
  has_many :roads
  has_many :tags
  has_many :classifications, :through => :mappings
  validates_presence_of :french, :english
  mount_uploader :icon, IconUploader

  scope :visible, lambda {where(:is_hidden => false)}

  scope :hidden, lambda {where(:is_hidden => true)}

  def json_object
    {:name => self.french, :icon => self.icon, :id => self.id}
  end

  def bilingual_name
    "#{self.french} / #{self.english}"
  end

  def self.dropdown_items
    connection = ActiveRecord::Base.connection
    connection.select_rows("SELECT french, id FROM categories ORDER BY french ASC")
  end

end
