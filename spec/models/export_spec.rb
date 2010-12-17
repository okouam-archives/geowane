require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Export do

  describe "when exporting locations" do

    before(:all) do
      10.times { Factory(:valid_location) }
    end

    it "saves the count of locations exported" do
      pending
    end

    it "exports the locations to a temporary .shp fileset" do
      pending  
    end

    it "compresses and archives the temporary .shp fileset" do
      pending
    end

    it "assigns the archived .shp fileset to the output of the export" do
      pending
    end

  end

end