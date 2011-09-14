require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Permissions do

  describe 'a collector' do

    before(:all) do
      @status_list = Location.new.statuses
      @collector = Factory.create(:collector, :role_name => "collector")
    end

    describe "when working a location he added" do

      before(:all) do
        @location = Factory(:location, :user => @collector)
      end

      it "cannot change his own locations which are not INVALID to any other status" do
        unchangeable_statuses = @status_list - [:invalid]
        unchangeable_statuses.each do |old_status|
          @status_list.each do |new_status|
            if new_status != old_status
              @location.status = old_status
              @collector.may_change_status_of_location?(@location, new_status).should be_false
            end
          end
        end
      end

      it "cannot change the status of his INVALID locations to anything else but CORRECTED" do
        unchangeable_statuses = @status_list - [:invalid, :corrected]
        @location.status = 'invalid'
        unchangeable_statuses.each do |new_status|
          @collector.may_change_status_of_location?(@location, new_status).should be_false
        end
      end

      it "can change the status of his INVALID locations to CORRECTED and INVALID" do
        @location.status = 'invalid'
        [:corrected, :invalid].each do |new_status|
          @collector.may_change_status_of_location?(@location, new_status).should be_true
        end
      end

    end

    describe "when working on a location added by someone else" do

      before(:all) do
        @location = Factory(:location)
      end

      it "cannot change anyone else's locations" do
        @status_list.each do |old_status|
          @status_list.each do |new_status|
            @location.status = old_status
            @collector.may_change_status_of_location?(@location, new_status).should be_false
          end
        end
      end

    end

  end

end