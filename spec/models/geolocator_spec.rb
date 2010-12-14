require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Geolocator do

  describe "when normalizing text" do

    it "returns an empty string if nothing is provided" do
      Geolocator.new.normalize(nil).should eql("")
    end

    it "removes accents" do
      Geolocator.new.normalize("é").should eql("e")
    end

    it "lowercases characters" do
      Geolocator.new.normalize("E").should eql("e")
    end

  end

  describe "when creating an unique name" do

    it "returns a blank string if the location has no name" do
      location = Factory.build(:valid_location, :name => "")
      Geolocator.new.create_unique_name(location).should eql("")
    end

    it "returns a blank string if the location has no name" do
      location = Factory.build(:valid_location, :name => nil)
      Geolocator.new.create_unique_name(location).should eql("")
    end

    it "appends the city name if the location belongs to a city" do
      Factory(:valid_city, :name => "Abidjan", :feature => Geometry::square(:center => [0,0], :side => 10))
      location = Factory(:valid_location, :name => "0-One", :longitude => 0, :latitude => 0)
      Geolocator.new.create_unique_name(location).should eql("0-One, Abidjan")
    end

    it "appends the commune name if the location belongs to a commune" do
      Factory(:valid_commune, :name => "Plateau", :feature => Geometry::square(:center => [0,0], :side => 10))
      location = Factory.build(:valid_location, :name => "0-One", :longitude => 0, :latitude => 0)
      Geolocator.new.create_unique_name(location).should eql("0-One, Plateau")
    end

    it "appends the region name if the location belongs to a region" do
      Factory(:valid_region, :name => "Les Lacs", :feature => Geometry::square(:center => [0,0], :side => 10))
      location = Factory.build(:valid_location, :name => "0-One", :longitude => 0, :latitude => 0)
      Geolocator.new.create_unique_name(location).should eql("0-One, Les Lacs")
    end

    it "concatenates the location attributes if several are provided" do
      Factory(:valid_city, :name => "Abidjan", :feature => Geometry::square(:center => [0,0], :side => 10))
      Factory(:valid_commune, :name => "Plateau", :feature => Geometry::square(:center => [0,0], :side => 10))
      Factory(:valid_region, :name => "Les Lacs", :feature => Geometry::square(:center => [0,0], :side => 10))
      location = Factory.build(:valid_location, :name => "0-One")
      Geolocator.new.create_unique_name(location).should eql("0-One, Plateau, Abidjan, Les Lacs")
    end

  end

end