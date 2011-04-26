class Category < ActiveRecord::Base
  has_many :tags
  has_many :locations, :through => :tags
  validates_presence_of :french, :english
  has_many :tags
  has_serialized :extensions,
                 :website => false, :telephone => false, :fax => false, :postal_address => false, :opening_hours => false,
                 :email => false, :user_rating => false, :twitter => false, :facebook_page => false


  def json_object
    {:name => self.french, :icon => self.icon, :id => self.id}
  end

  def bilingual_name
    "#{self.french} / #{self.english}"
  end

  def self.dropdown_items
    sql = "SELECT id, french FROM categories ORDER BY french ASC"
    Category.connection.select_all(sql).map {|rs| [rs["french"], rs["id"]]}
  end

  def self.available_icons
    Dir[File.expand_path(File.join(Rails.root,'public/images/google/*'))].map {|file| file.gsub("#{Rails.root}/public/images/", "")}
  end

end
