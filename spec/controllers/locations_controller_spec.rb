require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "authlogic/test_case"

describe LocationsController do

  describe "handling GET to #next" do

    ["administrator", 'collector', 'auditor'].each do |role|

      describe "when the current user is a #{role}" do

        before(:each) do
          login_as(role)
        end

        describe "when there is no saved search" do

          it "redirects to #index" do
            get :next, :id => 34
            response.should redirect_to locations_path
          end

        end

        describe "when there is a saved search" do

          before(:each) do
            session[:current_search] = {:query => "SELECT * FROM locations"}
            Location.stub(:find_by_sql).and_return([mock_model(Location, :id => 23), mock_model(Location, :id => 12), mock_model(Location, :id => 200)])
          end

          describe "and the current location is the last one" do

            it "redirects to the first location" do
              get :next, :id => 200
              response.should redirect_to edit_location_path(23)
            end

          end

          describe "and the current location is not the last one" do

            it "redirects to the next location" do
              get :next, :id => 23
              response.should redirect_to edit_location_path(12)
            end

          end

        end

      end

    end

  end

  describe "handling GET to #index" do

    ["administrator", 'collector', 'auditor'].each do |role|

      describe "when the current user is a #{role}" do

        before(:each) do
          login_as(role)
        end

        describe "and search parameters have been provided" do

          it "creates a search query using the given search filters" do
            Search.should_receive(:create).with({"x" => "z"}, nil).and_return(nil)
            Location.stub_chain(:paginate_by_sql)
            get :index, :s => {"x" => "z"}
          end

        end

        describe "and no search parameters have been provided" do

          it "creates a search query with no filters and the current user" do
            query = mock('query').as_null_object
            Search.should_receive(:create).with(nil, nil).and_return(query)
            Location.stub_chain(:paginate_by_sql)
            get :index
          end

        end

        it "paginates the query results" do
          Search.stub(:create)
          Location.should_receive(:paginate_by_sql)
          get :index
        end

        it "assigns the fetched locations to the view" do
          locations = mock('locations')
          Search.stub(:create)
          Location.stub(:paginate_by_sql).and_return(locations)
          get :index
          assigns(:locations).should == locations
        end

        it "saves the search query to the session" do
          query = "X"
          Search.stub(:create).and_return(query)
          Location.stub_chain(:paginate_by_sql)
          get :index
          session[:current_search][:query].should == "X"
        end

        it "saves the page number to the session" do
          Search.stub(:create)
          Location.stub_chain(:paginate_by_sql)
          get :index, :page => 12
          session[:current_search][:page].should == 12
        end

        it "saves the number of entries per page to the session" do
          query = mock('query').as_null_object
          Search.stub(:create).and_return(query)
          Location.stub_chain(:paginate_by_sql)
          get :index, :per_page => 32
          session[:current_search][:per_page].should == 32
        end

      end


    end

  end

  describe "handling PUT to #collection_update" do

    context "and removing a tag" do

    end

    context "and updating attributes" do

    end

    context "and adding a tag" do
      pending
    end

  end

end
