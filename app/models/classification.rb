class Classification < ActiveRecord::Base
  has_many :categories, :through => :mappings
  validate :name_must_be_provided

  def name_must_be_provided
    if french.blank? && english.blank?
      errors.add(:english, "All categories must have at least an english or french name")
      errors.add(:french, "All categories must have at least an english or french name")
    end
  end

  def self.dropdown_items
    Classification.order("name ASC").map {|classification| [classification.name, classification.id]}
  end

end