
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SearchCriteria do

  before(:all) do
    Location.delete_all
  end

  context "when searching with so parameters" do

    it "returns all locations" do
      Factory(:location)
      query = SearchCriteria.new.create_query
      query.count.should == 1
    end

  end

  context "when requesting a result ordering" do

    it "orders the results" do
      Factory(:location, :name => "K")
      Factory(:location, :name => "D")
      Factory(:location, :name => "H")
      query = SearchCriteria.new(nil, "locations.name").create_query
      query.first.name.should == "D"
    end

  end

  it "searches by city" do
    paris = Factory(:city, :name => "Paris")
    london = Factory(:city, :name => "London")
    Factory(:location, :city => paris)
    Factory(:location, :city => london)
    query = SearchCriteria.new({:city_id => paris.id}).create_query
    query.all.size.should == 1
    query.first.city_name.should == "Paris"
  end

  context "when filtering by model change" do

    before(:each) do
      @user = Factory(:administrator)
      Thread.current[:acts_as_audited_user] = @user
    end

    it "can search for locations modified by a given user" do
      Factory(:location)
      hotel = Factory(:location)
      hotel.update_attributes(:longitude => 12)
      query = SearchCriteria.new({:modified_by => @user.id}).create_query
      query.all.size.should == 1
    end

    it "can search for locations audited by a given user" do
      Factory(:location)
      hotel = Factory(:location)
      hotel.update_attributes(:status => "audited")
      query = SearchCriteria.new({:audited_by => @user.id}).create_query
      query.all.size.should == 1
    end

    it "can search for locations field checked by a given user" do
     Factory(:location)
      hotel = Factory(:location)
      hotel.update_attributes(:status => "field_checked")
      query = SearchCriteria.new({:confirmed_by => @user.id}).create_query
      query.all.size.should == 1
    end

  end

  context "when filtering by category" do

    it "filters by category when a category ID is provided" do
      hotels = Factory(:category)
      bars = Factory(:category)
      hotels.locations << Factory(:location)
      bars.locations << Factory(:location)
      query = SearchCriteria.new({:category_id => hotels.id}).create_query
      query.all.size.should == 1
    end

  end

  it "can search for locations created after a certain date" do
    Factory(:location, :created_at => DateTime.now + 3.days)
    Factory(:location)
    query = SearchCriteria.new({:added_on_after => (DateTime.now + 2.days).to_s}).create_query
    query.all.size.should == 1
  end

  it "can search for locations created before a certain date" do
    Factory(:location, :created_at => DateTime.now + 3.days)
    Factory(:location)
    query = SearchCriteria.new({:added_on_before => (DateTime.now + 2.days).to_s}).create_query
    query.all.size.should == 1
  end

  it "can filter by name" do
    Factory(:location, :name => "Residence Eburnea")
    Factory(:location, :name => "Sococe")
    query = SearchCriteria.new({:name=> "ebur"}).create_query
    query.all.size.should == 1
  end

  it "searches by label" do
    Factory(:location)
    location = Factory(:location)
    location.labels << Label.new(:key => "IMPORTED FROM", :value => "4", :classification => "SYSTEM")
    query = SearchCriteria.new({:import_id=> "4"}).create_query
    query.all.size.should == 1
  end

  context "when searching by boundary" do

    it "considers the most specific boundary" do
      hotel = Factory(:location)
      hotel.update_attributes(:level_0 => 384, :level_1 => 3944, :level_3 => 23)
      bar = Factory(:location)
      bar.update_attributes(:level_0 => 384)
      query = SearchCriteria.new({:location_level_1=> 3944, :location_level_0 => 384}).create_query
      query.all.size.should == 1
    end

  end

  it "searches by bbox" do
    Factory(:location, :longitude => 2, :latitude => 2)
    Factory(:location, :longitude => 0, :latitude => 0)
    query = SearchCriteria.new({:bbox => "1,-1,-1,1"}).create_query
    query.all.size.should == 1
  end

  it "can filter by status" do
    Factory(:location, :status => "invalid")
    Factory(:location, :status => "corrected")
    query = SearchCriteria.new({:status => "corrected"}).create_query
    query.all.size.should == 1
  end

end