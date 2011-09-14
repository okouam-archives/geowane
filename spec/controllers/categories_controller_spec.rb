require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "authlogic/test_case"
require 'aegis/spec/matchers'

describe CategoriesController do

  describe "handling GET to #index" do

    describe "when the user is a collector" do

      before(:each) do
        login_as_collector
      end

      it "is successful" do
        get :index
        response.status.should == 200
      end

      it "assigns the retrieved categories to the view" do
        Category.stub_chain(:find_by_sql, :paginate).and_return("A RESULT")
        get :index
        assigns(:categories).should == "A RESULT"
      end

      it "renders the #index template" do
        get :index
        response.should render_template("index")
      end

    end

  end

end