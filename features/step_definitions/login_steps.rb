When /^I have logged in as ([^\s]+) using the password ([^\s]+)/ do |username, password|
  steps %Q{
    Given I am on the login page"
    When I fill in "Login" with "#{username}"
    And I fill in "Password" with "#{password}"
    And I press "Login"
  }
end

Then /^I should see the message "([^"]*)" on the login page$/ do |msg|
  within("li.error_message") do
    should have_content(msg)
  end
end

Given /^I am a (.+) who has logged into the site$/ do |role|
    steps %Q{
      Given I am on the login page
      And the following valid #{role} exists:
        | login    | password | password_confirmation |
        | johnson  | corr9383 | corr9383              |
      And I fill in "Login" with "johnson"
      And I fill in "Password" with "corr9383"
      And I press "Login"
    }
end
