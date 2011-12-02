class Partner < ActiveRecord::Base
  has_many :partner_categories

  def self.dropdown_items
    Partner.order("name ASC").map {|partner| [partner.name, partner.id]}
	end

end