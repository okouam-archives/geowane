require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Import do

  describe "when inserting locations" do

    before(:all) do
      @example_gpx = Rails.root.join("spec/samples/example.gpx")
    end

    it "selects the correct importer" do
      import = Factory(:valid_gpx_import, :input => File.new(@example_gpx))
      Importers::GPX.stub(:new).and_return(mock('Import').as_null_object)
      import.insert
    end

    describe "and using the GPX importer" do

      it "uses Nokogiri to parse the file" do
        mock_document = mock('Document')
        mock_document.stub(:css).and_return([])
        Nokogiri.should_receive(:XML).and_return(mock_document)
        Importers::GPX.new.insert(@example_gpx, Factory(:valid_collector), 54)
      end

      it "counts the number of locations imported" do
        locations_count = Importers::GPX.new.insert(@example_gpx, Factory(:valid_collector), 54)
        locations_count.should == 1
      end

    end

  end

  describe "when updating from a .MP file" do

    before(:all) do
      @sample_mp = Rails.root.join("spec/samples/sample.mp")
    end

    it "does what it should" do
      Importers::MP.new.update(@sample_mp, [1,2])
    end

  end

end
