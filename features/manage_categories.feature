#noinspection CucumberUndefinedStep
Feature: Manage categories
  As an administrator
  In order to categorize locations
  I want to manage categories

  Scenario: Add a new category
    Given I am a administrator who has logged into the site
    When I go to the categories page
    And I follow "New Category"
    And I fill in "French" with "Magasins"
    And I fill in "English" with "Shops"
    And I press "Create Category"
    Then I should see the table listing:
      | Name     | Icon | Total POI | New | Corrected | Invalid | Audited | Field Checked |
      | Magasins |      | 0         | 0   | 0         | 0       | 0       | 0             |

  Scenario: Edit a category
    Given I am a administrator who has logged into the site
    And the following valid category exists:
      | French    |
      | Assurance |
    When I go to the categories page
    And I edit "Assurance" in the table listing
    And I fill in "French" with "Base militaire"
    And I press "Update Category"
    Then I should see the table listing:
      | Name           | Icon | Total POI | New | Corrected | Invalid | Audited | Field Checked |
      | Base militaire |      | 0         | 0   | 0         | 0       | 0       | 0             |

  Scenario: Delete a category
    Given I am a administrator who has logged into the site
    And the following valid categories exists:
      | French    |
      | Assurance |
      | Magasin   |
    When I go to the categories page
    And I delete "Assurance" in the table listing and click "OK"
    Then I should see the table listing:
      | Name    | Icon | Total POI | New | Corrected | Invalid | Audited | Field Checked |
      | Magasin |      | 0         | 0   | 0         | 0       | 0       | 0             |