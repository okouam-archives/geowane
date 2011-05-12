require File.dirname(__FILE__) + '/acceptance_helper'

feature "Navigating site" do

  scenario "Default page is the login page" do
    visit "/"
    page = Page.new(Capybara.current_session)
    page.has_title("GeoCMS - Login")
  end

  scenario "Must be logged in to access internal pages" do
    visit "/locations"
    page = Page.new(Capybara.current_session)
    page.has_title("GeoCMS - Login")
  end

  scenario "Committing changes to a POI returns the user to the previous POI selection" do

    somebody = Factory.create(:administrator, password: "XXXX", password_confirmation: "XXXX")

    page = Pages::Login.new(Capybara.current_session)
    page.visit
    page.login(somebody)

    page = Pages::Location::Index.new(Capybara.current_session)
    page.goto_page(3)
    page.edit_location("0-One")

    page = Pages::Location::Edit.new(Capybara.current_session)
    page.save

    page = Pages::Location::Index.new(Capybara.current_session)
    assert page.is_on_page?(3)

  end

  scenario "Committing changes to a collection of POI returns the user to the previous POI selection" do

    somebody = Factory.create(:administrator, password: "XXXX", password_confirmation: "XXXX")

    page = Pages::Login.new(Capybara.current_session)
    page.visit
    page.login(somebody)

    page = Pages::Location::Index.new(Capybara.current_session)
    page.goto_page(3)
    page.pick_location("0-One")
    page.edit_selection

    page = Pages::Location::CollectionEdit.new(Capybara.current_session)
    page.commit_changes

    page = Pages::Location::Index.new(Capybara.current_session)
    assert page.is_on_page?(3)

  end

end