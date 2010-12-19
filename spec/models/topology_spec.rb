require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Topology do

  before(:all) do
    @england = Factory(:valid_country, :feature => Geometry::square(:center => [0,0], :side => 100))
    @dorset = Factory(:valid_region, :feature => Geometry::square(:center => [0,0], :side => 8))
    @london = Factory(:valid_city, :feature => Geometry::square(:center => [0,0], :side => 6))
    @barnet = Factory(:valid_commune, :feature => Geometry::square(:center => [0,0], :side => 4))
    @yorkshire = Factory(:valid_region, :feature => Geometry::square(:center => [25,25], :side => 8))
  end

  describe "when a location is created" do

    before(:each) do
      @a = Factory(:valid_location, :longitude => 0, :latitude => 0)
      @b = Factory(:valid_location, :longitude => 25, :latitude => 25)
    end

    it "creates a topology" do
      Topology.count(:all).should == 2
    end

    it "assigns the correct topology to locations" do
      a = Topology.find_by_location_id(@a.id)
      a.country.should == @england
      a.region.should == @dorset
      a.city.should == @london
      a.commune.should == @barnet
      b = Topology.find_by_location_id(@b.id)
      b.country.should == @england
      b.region.should == @yorkshire
      b.commune.should be_nil
      b.city.should be_nil
    end
  
  end

  describe "when a location is updated" do

    before(:each) do
      @a = Factory(:valid_location, :longitude => 0, :latitude => 0)
    end

    it "updates the corresponding topology" do
      a = Topology.find_by_location_id(@a.id)
      a.region.should == @dorset
      @a.update_attributes(:longitude => 25, :latitude => 25)
      @a.save!
      a.reload
      a.region.should == @yorkshire 
    end

  end

  describe "when a location is deleted" do

    before(:each) do
      @a = Factory(:valid_location, :longitude => 0, :latitude => 0)
    end

    it "removes the corresponding topology" do
      @a.destroy
      Topology.count(:all).should == 0   
    end

  end

end
