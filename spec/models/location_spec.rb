require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Location do

  it "creates a new instance given valid attributes" do
    Location.create!(:longitude => 1, :latitude => 2, :name => "test", :user => Factory(:valid_collector))
  end

  describe "when instantiated" do

    it "has a status of 'NEW'" do
      location = Factory.build(:valid_location)
      location.status.should == "NEW"
    end

  end

  describe "when created outside a workflow" do

    subject { Factory.create(:valid_location) }

    it "creates an audit without an associated user" do
      subject.audits.count.should == 1
      subject.audits.first.user.should == nil
    end

    it "creates an audit with a model change for each attribute" do
      subject.audits.first.model_changes.count.should == subject.audited_attributes.count
    end

  end

  describe "when created within a workflow" do

    let(:collector) {Factory(:valid_collector)}

    subject do
      Audit.as_user collector do
        Factory(:valid_location)
      end
    end

    it "creates an audit with an associated user" do
      subject.audits.count.should == 1
      subject.audits.first.user.should == collector
    end

  end

  it "finds the city in which it is located" do
    city = Factory(:valid_city, :feature => Geometry::square(:center => [110,0], :side => 10))
    location = Factory.build(:valid_location, :longitude => 110, :latitude => 0)
    location.city.should == city
  end

  it "finds the commune in which it is located" do
    commune = Factory(:valid_commune, :feature => Geometry::square(:center => [50,0], :side => 10))
    location = Factory.build(:valid_location, :longitude => 50, :latitude => 0)
    location.commune.should == commune
  end

  it "finds the region in which it is located" do
    region = Factory(:valid_region, :feature => Geometry::square(:center => [20,0], :side => 10))
    location = Factory.build(:valid_location, :longitude => 20, :latitude => 0)
    location.region.should == region
  end

  describe "when serializing to a JSON object" do

    it "can serialize a location outside any city" do
      location = Factory(:valid_location)
      location.json_object[:city].should be_nil
    end

    it "can serialize a location outside any region" do
      location = Factory(:valid_location)
      location.json_object[:region].should be_nil
    end

    it "can serialize a location outside any commune" do
      location = Factory(:valid_location)
      location.json_object[:commune].should be_nil
    end

    it "can serialize a location outside any country" do
      location = Factory(:valid_location)
      location.json_object[:country].should be_nil
    end

    it "uses all optional attributes when available" do
      Factory(:valid_region, :name => "Centre", :feature => Geometry::square(:center => [0,0], :side => 10))
      Factory(:valid_city, :name => "Bouaké", :feature => Geometry::square(:center => [0,0], :side => 10))
      Factory(:valid_commune, :name => "Plateau", :feature => Geometry::square(:center => [0,0], :side => 10))
      category = Factory(:valid_category)
      location = Factory(:valid_location, :name => "0-One", :longitude => 0, :latitude => 0, :category => category)
      json = location.json_object
      json[:region].should_not be_nil
      json[:city].should_not be_nil
      json[:commune].should_not be_nil
      json[:icon].should_not be_nil
    end

  end

  describe "when saving" do

    it "cannot be saved without a name" do
      location = Location.new(:longitude => 1, :latitude => 2, :user => Factory(:valid_collector))
      location.save
      location.errors.size.should eql(1)
    end

    it "cannot be saved without a longitude" do
      location = Location.new(:latitude => 2, :name => "test", :user => Factory(:valid_collector))
      location.save
      location.errors.size.should eql(1)
    end

    it "cannot be saved without a latitude" do
      location = Location.new(:longitude => 1, :name => "test", :user => Factory(:valid_collector))
      location.save
      location.errors.size.should eql(1)
    end

    it "updates its feature" do
      location = Location.new(:longitude => 1, :latitude => 2, :name => "test", :user => Factory(:valid_collector))
      location.save!
      location.feature.should_not be_nil
      location.feature.x.should == 1
      location.feature.y.should == 2
    end

  end

end
