class Import < ActiveRecord::Base
  has_attached_file :input
  validates_format_of :input_file_name, :with => /\.(mp|gpx|csv)/
  validates_attachment_presence :input
  belongs_to :user
  has_many :locations
  has_many :selections          
  after_post_process :identify_selection
  default_scope :order => "created_at DESC"

  def execute(selected_items)
    importer_for(self.input.path).execute(self, selected_items)
  end

  private

  def identify_selection
    file = input.queued_for_write[:original].path
    importer_for(file).create_selection(self, file)
  end

  def importer_for(file)
    "Importers::#{import_format(file)}".constantize.new
  end
  
  def import_format(file)
    File.extname(file)[1..-1].upcase
  end

end
  