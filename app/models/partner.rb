class Partner < ActiveRecord::Base
  has_many :mappings
  accepts_nested_attributes_for :mappings, :allow_destroy => true,
                                :reject_if => proc { |a| a['english'].blank? && a['french'].blank? }


end