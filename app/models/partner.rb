class Partner < ActiveRecord::Base
  has_many :classifications

  def self.dropdown_items
    Partner.order("name ASC").map {|partner| [partner.name, partner.id]}
  end

end