require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Level do

  before(:all) do
    @example_shp = File.expand_path(File.join(File.dirname(__FILE__), "../samples/SEN_NIVEAU0.shp"))
  end

  describe "when importing a level" do

    it "infers the level from the filename" do
      pending          
    end

    it "opens the file" do
      File.stub(:exists?).and_return(true)
      GeoRuby::Shp4r::ShpFile.should_receive(:open).with("x")
      Level.new.import("x", 0)  
    end

    it "processes each available shape" do
      shp = mock('shape')
      shp.should_receive(:each)
     	GeoRuby::Shp4r::ShpFile.stub(:open).with("x").and_return(shp)
     	File.stub(:exists?).and_return(true)
      Level.new.import("x", 0)  
    end

    it "creates a SQL statement for each shape" do
      Level.should_receive(:create_sql)
      Level.new.import(@example_shp, 0)  
    end

  end

end
