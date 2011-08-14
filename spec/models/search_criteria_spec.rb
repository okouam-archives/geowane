
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SearchCriteria do

  before(:all) do
    Location.delete_all
  end

  context "when searching with so parameters" do

    it "returns all locations" do
      Factory(:location)
      query = SearchCriteria.create_sql
      query.count.should == 1
    end

  end

  context "when requesting a result ordering" do

    it "orders the results" do
      Factory(:location, :name => "K")
      Factory(:location, :name => "D")
      Factory(:location, :name => "H")
      query = SearchCriteria.create_sql(nil, "locations.name")
      query.first.name.should == "D"
    end

  end

  it "searches by city" do
    paris = Factory(:city, :name => "Paris")
    london = Factory(:city, :name => "London")
    Factory(:location, :city => paris)
    Factory(:location, :city => london)
    query = SearchCriteria.create_sql({:city_id => paris.id})
    query.all.size.should == 1
    query.first.city_name.should == "Paris"
  end

  it "searches by classification" do
    hotels = Factory(:category)
    hotels.locations << Factory(:location)
    classification = Factory(:classification)
    classification.categories << hotels
    query = SearchCriteria.create_sql({:classification_id => classification.id})
    query.all.size.should == 1
  end

  it "searches for locations with no categories" do
    hotels = Factory(:category)
    hotels.locations << Factory(:location)
    Factory(:location)
    query = SearchCriteria.create_sql({:category_missing => "1"})
    puts query.to_sql
    query.all.size.should == 1
  end

  it "searches for locations in any category" do
    hotels = Factory(:category)
    hotels.locations << Factory(:location)
    Factory(:location)
    query = SearchCriteria.create_sql({:category_present => "1"})
    query.all.size.should == 1
  end

  it "searches for locations created after a certain date" do
    Factory(:location, :created_at => DateTime.now + 3.days)
    Factory(:location)
    query = SearchCriteria.create_sql({:added_on_after => (DateTime.now + 2.days).to_s})
    query.all.size.should == 1
  end

  it "searches for locations created before a certain date" do
    Factory(:location, :created_at => DateTime.now + 3.days)
    Factory(:location)
    query = SearchCriteria.create_sql({:added_on_before => (DateTime.now + 2.days).to_s})
    query.all.size.should == 1
  end

  it "searches by name" do
    Factory(:location, :name => "Residence Eburnea")
    Factory(:location, :name => "Sococe")
    query = SearchCriteria.create_sql({:name=> "ebur"})
    query.all.size.should == 1
  end

  it "searches by label" do
    pending
  end

  context "when searching by boundary" do

    it "considers the most specific boundary" do
      Factory(:location, :level_0 => 384, :level_1 => 3944, :level_3 => 23)
      Factory(:location, :level_0 => 384)
      query = SearchCriteria.create_sql({:location_level_1=> 3944, :location_level_0 => 384})
      query.all.size.should == 1
    end

    it "returns non-geolocated locations" do
      Factory(:location, :level_0 => 384)
      Factory(:location)
      query = SearchCriteria.create_sql({:location_level_1=> 3944, :location_level_0 => 384})
      query.all.size.should == 1
    end

  end

  it "searches by bbox" do
    pending
  end

  it "searches by boundary" do
    pending
  end

  it "searches by category when a category ID is provided" do
    hotels = Factory(:category)
    bars = Factory(:category)
    hotels.locations << Factory(:location)
    bars.locations << Factory(:location)
    query = SearchCriteria.create_sql({:category_id => hotels.id})
    query.all.size.should == 1
  end

  it "searches by status" do
    Factory(:location, :status => "invalid")
    Factory(:location, :status => "corrected")
    query = SearchCriteria.create_sql({:status => "corrected"})
    query.to_sql
    query.all.size.should == 1
  end

end