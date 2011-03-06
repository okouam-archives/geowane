# coding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Location do

  it "creates a new instance given valid attributes" do
    Location.create!(:longitude => 1, :latitude => 2, :name => "test", :user => Factory(:valid_collector))
  end

  describe "when instantiated" do

    it "has a status of 'NEW'" do
      location = Factory.build(:valid_location)
      location.status.should == :new
    end

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
