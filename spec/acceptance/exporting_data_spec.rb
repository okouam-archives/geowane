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

  scenario "A subset of the database can be selected for export" do

    somebody = Factory.create(:collector)

    page = Pages::Login.new(Capybara.current_session)
    page.visit
    page.login(somebody)

    page = Pages::Export::Index.new(Capybara.current_session)
    page.visit
    page.create_selection

    page = Pages::Export::Selection.new(Capybara.current_session)
    page.countries("Côte d'Ivoire")
    page.categories("Arrêt de bus")
    page.users("fode.samake")
    page.states("Corrected", "Audited", "Invalid")
    page.export

    page = Pages::Export::Output.new(Capybara.current_session)
    page.output_format(".SHP")
    page.name("my file")
    page.output_platform("WINDOWS")
    page.process_file

  end

  scenario "Exports can be browsed" do
    pending
  end

end
