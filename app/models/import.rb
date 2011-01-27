require 'enumerated_attribute'

class Import < ActiveRecord::Base
  has_attached_file :input
  belongs_to :user
  has_many :locations
  has_many :selections          
  after_post_process :identify_selection

  def self.paged(page, per_page)
    Import.order("created_at desc").paginate(:page => page, :per_page => per_page)
  end

  def execute(selected_items)
    importer_for(self.input.path).execute(self, selected_items)
  end

  def labelled_locations
    Location.joins(:labels).where("labels.classification = 'SYSTEM'").where("labels.key = 'IMPORTED FROM'")
      .where("labels.value = '#{id}'").count
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
  