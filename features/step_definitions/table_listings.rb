When /^I ([^\s]+) "([^"]*)" in the table listing$/ do |link, cell_value|
  row_xpath = "//*[.//td[contains(.,'#{cell_value}')] and .//a[text()='#{link.titleize}']]"
  find(:xpath, row_xpath).find_link(link.titleize).click
end

When /^I ([^\s]+) "([^"]*)" in the table listing and click "OK"/ do |link, cell_value|
  page.evaluate_script("window.alert = function(msg) { return true; }")
  page.evaluate_script("window.confirm = function(msg) { return true; }")
  When %{I #{link} "#{cell_value}" in the table listing}
end

Then /^I should see the table listing/ do |expected_table|
  html_table = tableish("table.list tr", "td, th").to_a
  html_table.map! { |r| r.map! { |c| c.gsub(/<.+?>/, '') } }
  expected_table.diff!(html_table)
end

Then /^I should not be able to ([^\s]+) "([^"]*)" in the table listing$/ do |action, cell_value|
  row_xpath = "//*[.//td[contains(.,'#{cell_value}')] and .//a[text()='#{action.titleize}']]"
  page.should have_no_xpath(row_xpath)
end

Then /^I should be able to ([^\s]+) "([^"]*)" in the table listing$/ do |action, cell_value|
  row_xpath = "//*[.//td[contains(.,'#{cell_value}')] and .//a[text()='#{action.titleize}']]"
  page.should have_xpath(row_xpath)
end

Then /^I should see an empty table listing$/ do
  page.should have_no_css('table.list td')
end