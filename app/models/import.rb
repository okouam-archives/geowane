require 'enumerated_attribute'

class Import < ActiveRecord::Base
  has_attached_file :input
  belongs_to :user
  validates_presence_of :import_format, :user
  enum_attr :import_format, %w(^GPX SHP MP)
  has_many :locations

  def preview
    importer.preview(self.input.path)
  end

  def update(selection)
    importer.update(self.input.path, selection)
  end

  def insert
    importer.insert(self.input.path, self.user, self.id)
  end

  def importer
    "Importers::#{self.import_format}".constantize.new
  end

end
