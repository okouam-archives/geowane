Feature: Login to the site
  In order to make use of the site
  A user should be able to log into the site

  Scenario: A user attempts to login without providing any credentials
    Given I am on the login page
    When I press "Login"
    Then I should see the message "You did not provide any details for authentication." on the login page

  Scenario: A user attempts to login with an invalid username
    Given I am on the login page
    And the following valid collector exists:
      | login   | password | password_confirmation |
      | johnson | corr9383 | corr9383              |
    When I fill in "Login" with "john"
    And I fill in "Password" with "corr9383"
    And I press "Login"
    Then I should see the message "Login is not valid" on the login page

  Scenario: A user attempts to login with an invalid password
    Given I am on the login page
    And the following valid collector exists:
      | login    | password  | password_confirmation |
      | johnson  | corr9383  | corr9383              |
    When I fill in "Login" with "johnson"
    And I fill in "Password" with "corr1111"
    And I press "Login"
    And show me the page
    Then I should see the message "Password is not valid" on the login page

  @current
  Scenario: A user logs with valid credentials
    Given I am on the login page
    And the following valid collector exists:
      | login    | password | password_confirmation |
      | johnson  | minty    | minty                 |
    When I fill in "Login" with "johnson"
    And I fill in "Password" with "minty"
    And I press "Login"
    Then I should be on the dashboard page

  Scenario: A user attempts to login with valid but inactive credentials
    Given I am on the login page
    And the following valid collector exists:
      | login    | password | password_confirmation | is_active |
      | johnson  | corr9383 | corr9383              | false     |
    When I fill in "Login" with "johnson"
    And I fill in "Password" with "corr9383"
    And I press "Login"
    Then I should see the message "You do not have the right to access the GeoCMS." on the login page