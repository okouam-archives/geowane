Feature: Category Management
  In order to categorize points of interest
  As a administrator
  I want to be able to manage categories

  Scenario: Add a new category
    Given I am an administrator
    And I am on the category creation page
    When I add the following category:
      | french | english | code   | is_landmark | is_hidden |
      | Cartes | Cards   | 434AAB | false       | false     |
    Then I should be on the categories page
    And I should see the following category in the listing:
      | french | english |
      | Cartes | Cards   |

  Scenario: Delete a category

  Scenario: Edit a category