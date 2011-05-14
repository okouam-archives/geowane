require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "authlogic/test_case"

describe CommentsController do

  describe "handling POST to #collection_create" do

    it "returns an error if no comment provided" do
      location = Factory.create(:location)
      post :collection_create, locations: [location.id]
      puts response
      response.status.should == 403
    end

    it "returns an error if any location ID supplied does not correspond to a location" do
      location = Factory.create(:location)
      post :collection_create, locations: [location.id, 99999999]
      response.status.should == 403
    end

    it "returns an error if no locations provided" do
      post :collection_create, comment: "Nothing to see here"
      response.status.should == 403
    end

    it "creates a comment for each location supplied" do

    end


  end

end