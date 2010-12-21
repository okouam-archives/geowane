require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Import do

  @example_gpx = File.expand_path(File.join(File.dirname(__FILE__), "../samples/example.gpx"))

  describe "when importing locations" do

    it "selects the correct importer" do
      import = Factory(:valid_gpx_import, :input => @example_gpx)
      
      import.execute
    end

    it "assigns the number of locations imported" do
      pending
    end

    describe "and using the GPX importer" do

      it "uses Nokogiri to parse the file" do
        pending
      end

      it "ignores any node with a blank name" do
        pending
      end

      it "counts the number of locations imported" do
        pending  
      end

      it "creates a location for each valid node" do
        pending
      end

    end

  end

end
