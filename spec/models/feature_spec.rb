require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Feature do

  BENIN_SHAPEFILES = "/home/okouam/Dropbox/0-One/Operations/Technical/Mapping/Shapefiles/Bénin"

  describe "when importing" do

    it "loads the shapefile data into the database" do
      Feature.import(BENIN_SHAPEFILES)      
    end
    
  end

end
