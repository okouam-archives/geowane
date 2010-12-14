require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'aegis/spec/matchers'

describe "Permissions" do
  include Aegis::Spec::Matchers

  describe "when the user is a collector" do

    before(:all) do
      @collector = Factory(:valid_collector)
    end

    describe "updating a location he has added"  do

      before(:each) do
        @location = Factory(:valid_location, :user => @collector)
      end

      it "is allowed when the location has a status of NEW or INVALID" do
        @location.send :status=, "NEW"
        @collector.should be_allowed_to(:update_location, @location)
        @location.send :status=, "INVALID"
        @collector.should be_allowed_to(:update_location, @location)
      end

      it "is denied when the location has a status of AUDITED or CORRECTED or FIELD CHECKED" do
        @location.send :status=, "AUDITED"
        @collector.should_not be_allowed_to(:update_location, @location)
        @location.send :status=, "CORRECTED"
        @collector.should_not be_allowed_to(:update_location, @location)
        @location.send :status=, "FIELD CHECKED"
        @collector.should_not be_allowed_to(:update_location, @location)
      end

    end

    it "is denied when trying to update a location he has not added" do
      location = Factory(:valid_location)
      @collector.should_not be_allowed_to(:update_location, location)
    end

    describe "deleting a location he's added" do

      before(:each) do
        @location = Factory(:valid_location, :user => @collector)
      end

      it "is allowed when the location has a status of NEW or INVALID" do
        @location.send :status=, "NEW"
        @collector.should be_allowed_to(:destroy_location, @location)
        @location.send :status=, "INVALID"
        @collector.should be_allowed_to(:destroy_location, @location)
      end

      it "is denied when the location has a status of AUDITED or CORRECTED or FIELD CHECKED" do
        @location.send :status=, "AUDITED"
        @collector.should_not be_allowed_to(:destroy_location, @location)
        @location.send :status=, "CORRECTED"
        @collector.should_not be_allowed_to(:destroy_location, @location)
        @location.send :status=, "FIELD CHECKED"
        @collector.should_not be_allowed_to(:destroy_location, @location)
      end

    end

    it "is denied when trying to deleted a location he has not added" do
      location = Factory(:valid_location)
      @collector.should_not be_allowed_to(:delete_location, location)
    end

    describe "changing the status of a location he has added" do

      before(:each) do
        @location = Factory(:valid_location, :user => @collector)
      end

      it "is allowed when the original status is INVALID" do
        @location.send :status=, "INVALID"
        @collector.should be_allowed_to(:change_status_of_location, @location, 'CORRECTED')
      end

      it "is denied when the original status is anything other than INVALID" do
        @states = Location.workflow_states - ["INVALID", "CORRECTED"]
        @states.each do |state|
          @location.send :status=, state
          @collector.should_not be_allowed_to(:change_status_of_location, @location, 'CORRECTED')
        end
      end

      it "is allowed to change the status from INVALID to CORRECTED" do
        @location.send :status=, "INVALID"
        @collector.should be_allowed_to(:change_status_of_location, @location, 'CORRECTED')
      end

      it "is denied when the change is any other transition" do
        @location.send :status=, "INVALID"
        @states = Location.workflow_states - ["CORRECTED", "INVALID"]
        @states.each do |state|
          @collector.should_not be_allowed_to(:change_status_of_location, @location, state)
        end
      end

    end

    it "is denied when trying to change the status of a location he has not added" do
      location = Factory(:valid_location)
      Location.workflow_states.each do |state|
        location.send :status=, state
        Location.workflow_states.each do |new_state|
          next if new_state == state
          @collector.should_not be_allowed_to(:change_status_of_location, location, new_state)
        end
      end
    end

  end

end