class Partner < ActiveRecord::Base
  has_many :categories, :class_name => "PartnerCategory"

  def self.dropdown_items
    Partner.order("name ASC").map {|partner| [partner.name, partner.id]}
  end

end