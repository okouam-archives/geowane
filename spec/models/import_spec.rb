require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Import do

  before(:all) do
    @example_gpx = Rails.root.join("spec/samples/example.gpx")
  end

  describe "when importing locations" do

    it "selects the correct importer" do
      import = Factory(:valid_gpx_import, :input => File.new(@example_gpx))
      Import::Importers::GPX.stub(:new).and_return(mock('Import').as_null_object) 
      import.execute
    end

    it "assigns the number of locations imported" do
      import = Factory(:valid_gpx_import, :input => File.new(@example_gpx))
      mock = mock('Import', :execute => 484)
      Import::Importers::GPX.stub(:new).and_return(mock) 
      import.execute
      import.locations_count.should == 484
    end

    describe "and using the GPX importer" do

      it "uses Nokogiri to parse the file" do
        mock_document = mock('Document')
        mock_document.stub(:css).and_return([])
        Nokogiri.should_receive(:XML).and_return(mock_document)
        Import::Importers::GPX.new.execute(@example_gpx, Factory(:valid_collector), 54)
      end

      it "counts the number of locations imported" do
        locations_count = Import::Importers::GPX.new.execute(@example_gpx, Factory(:valid_collector), 54)
        locations_count.should == 7
      end

    end

  end

end
