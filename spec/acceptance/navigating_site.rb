# encoding: utf-8

require File.dirname(__FILE__) + '/acceptance_helper'

feature "Navigating site" do

  scenario "Default page is the login page" do
    visit "/"
    page = Pages::Page.new(Capybara.current_session)
    page.has_title?("GeoCMS - Login").should be_true
  end

  scenario "Must be logged in to access internal pages" do
    visit "/locations"
    page = Pages::Page.new(Capybara.current_session)
    page.has_title?("GeoCMS - Login").should be_true
  end

  scenario "Committing changes to a POI returns the user to the previous POI selection" do

    somebody = Factory.create(:administrator)

    40.times do
      Factory.create(:location, :user => somebody)
    end

    page = Pages::Login.new(Capybara.current_session)
    page.visit
    page.login(somebody)

    page = Pages::Location::Index.new(Capybara.current_session)
    page.visit
    page.goto_page(3)
    page.is_on_page?(3).should be_true
    poi = page.item_at_row(5)
    page.edit_location(poi)

    page = Pages::Location::Edit.new(Capybara.current_session)
    page.save

    page = Pages::Location::Index.new(Capybara.current_session)
    Capybara.current_session.save_and_open_page
    page.is_on_page?(3).should be_true
    page.item_at_row(5).should == poi

  end

  scenario "Committing changes to a collection of POI returns the user to the previous POI selection" do

    somebody = Factory.create(:administrator)

    40.times do
      Factory.create(:location, :user => somebody)
    end

    somebody = Factory.create(:administrator)

    page = Pages::Login.new(Capybara.current_session)
    page.visit
    page.login(somebody)

    page = Pages::Location::Index.new(Capybara.current_session)
    page.visit
    page.goto_page(3)
    poi = page.item_at_row(5)
    page.pick_location(poi)
    page.edit_selection

    page = Pages::Location::CollectionEdit.new(Capybara.current_session)
    page.commit_changes

    page = Pages::Location::Index.new(Capybara.current_session)
    page.is_on_page?(3).should be_true
    page.item_at_row(5).should == poi

  end

end