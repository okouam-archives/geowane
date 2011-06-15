require File.dirname(__FILE__) + '/../acceptance_helper'
require 'rack/test'

feature "Using the Categories API" do

  include Rails.application.routes.url_helpers

  def app
    Gowane::Application
  end

  describe "GET /api/categories" do

    scenario "is successful" do
      get '/api/categories'
      ActiveSupport::JSON.decode(last_response.body)
      last_response.should be_ok
    end

    scenario "fetches all categories having locations" do
      categories = [Factory.create(:category), Factory.create(:category), Factory.create(:category)]
      categories.each do |category|
        category.locations << Factory.create(:location)
        category.save!
      end
      get '/api/categories'
      result = ActiveSupport::JSON.decode(last_response.body)
      result.size.should == 3
    end

    scenario "does not fetch categories without any locations" do
      Factory.create(:category)
      get '/api/categories'
      result = ActiveSupport::JSON.decode(last_response.body)
      result.size.should == 0
    end

  end

end