# encoding: utf-8

require File.dirname(__FILE__) + '/acceptance_helper'

feature "Exporting data" do

  scenario "Collectors are not allowed to export data" do
    somebody = Factory.create(:collector)
    page = Pages::Login.new(Capybara.current_session)
    page.visit
    page.login(somebody)
    page = Pages::Page.new(Capybara.current_session)
    page.has_menu_item?("Export Data").should be_false
  end

  scenario "Auditors are not allowed to export data" do
    somebody = Factory.create(:auditor)
    page = Pages::Login.new(Capybara.current_session)
    page.visit
    page.login(somebody)
    page = Pages::Page.new(Capybara.current_session)
    page.has_menu_item?("Export Data").should be_false
  end

  scenario "Administrators are allowed to export data" do
    somebody = Factory.create(:administrator)
    page = Pages::Login.new(Capybara.current_session)
    page.visit
    page.login(somebody)
    page = Pages::Page.new(Capybara.current_session)
    page.has_menu_item?("Export Data").should be_true
  end

end
