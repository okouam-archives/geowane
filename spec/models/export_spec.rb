require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Export do

  describe "when exporting locations" do

    before(:all) do
      10.times { Factory(:valid_location) }
    end

    it "saves the count of locations exported" do
      export = Export.new(:name => "testing", :output_format => ".SHP")
      export.execute(Location.all)
      export.locations_count = 10
    end

  end

end
