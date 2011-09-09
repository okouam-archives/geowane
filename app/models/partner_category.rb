class PartnerCategory < ActiveRecord::Base
  validate :name_must_be_provided
  has_many :categories, :through => :mappings
  has_many :mappings
  belongs_to :partner
  mount_uploader :icon, IconUploader

  default_scope :order => 'french ASC'

  def name_must_be_provided
    if french.blank? && english.blank?
      errors.add(:english, "All categories must have at least an english or french name")
      errors.add(:french, "All categories must have at least an english or french name")
    end
  end

end

