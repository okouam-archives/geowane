Then /^I should see the error message "([^"]*)"$/ do |msg|
  within("li.error_message") do
    should have_content(msg)
  end
end