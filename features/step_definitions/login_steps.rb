When /^I have logged in as ([^\s]+) using the password ([^\s]+)/ do |username, password|
    Given "I am on the login page"
    When "I fill in \"Login\" with \"#{username}\""
    And "I fill in \"Password\" with \"#{password}\""
    And "I press \"Login\""
end

Then /^I should see the message "([^"]*)" on the login page$/ do |msg|
  within("li.error_message") do
    should have_content(msg)
  end
end
Given /^I am an auditor who has logged into the site$/ do
  pending
end
When /^the following valid collector exists:$/ do |table|
  # table is a | johnson | corr9383 | corr9383              |
  pending
end