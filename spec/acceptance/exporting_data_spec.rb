require File.dirname(__FILE__) + '/acceptance_helper'

feature "Exporting data" do

  scenario "Collectors are not allowed to export data" do

  end

  scenario "Auditors and administrators are allowed to export data" do
    pending
  end

  scenario "A subset of the database can be selected for export" do
    somebody = Factory(:collector)
    log_in somebody
    visit "/exports"
    click_on "Create Selection"
    select "Cote d'Ivoire"
    select "All locations"

  end

  scenario "Exports can be browsed" do
    pending
  end

end
