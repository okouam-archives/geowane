
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SearchCriteria do

  before(:all) do
    Location.delete_all
  end

  context "when searching with no parameters" do

    it "returns all locations" do
      Factory(:location)
      query = SearchCriteria.new({}).create_query
      query.count.should == 1
    end

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
      query = SearchCriteria.new({:modified_by => [@user.id]}).create_query
      query.all.size.should == 1
    end

    it "can search for locations audited by a given user" do
      Factory(:location)
      hotel = Factory(:location)
      hotel.update_attributes(:status => "audited")
      query = SearchCriteria.new({:audited_by => [@user.id]}).create_query
      query.all.size.should == 1
    end

    it "can search for locations field checked by a given user" do
     Factory(:location)
      hotel = Factory(:location)
      hotel.update_attributes(:status => "field_checked")
      query = SearchCriteria.new({:confirmed_by => [@user.id]}).create_query
      query.all.size.should == 1
    end

  end

  context "when filtering by category" do

    it "filters by category when a category ID is provided" do
      hotels = Factory(:category)
      bars = Factory(:category)
      hotels.locations << Factory(:location)
      bars.locations << Factory(:location)
      query = SearchCriteria.new({:categories => [hotels.id]}).create_query
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

    it "can search by boundary" do
      hotel = Factory(:location)
      hotel.update_attributes(:level_0 => 384)
      bar = Factory(:location)
      bar.update_attributes(:level_0 => 3944)
      query = SearchCriteria.new({:level_id=> 3944}).create_query
      query.all.size.should == 1
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
    query = SearchCriteria.new({:statuses => ["corrected"]}).create_query
    query.all.size.should == 1
  end

end