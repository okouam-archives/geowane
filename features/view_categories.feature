Feature: View categories
  As a user
  In order to categorize locations
  I want to be able to view categories and their associated actions

  Scenario: View an empty category list
    Given I am a collector who has logged into the site
    When I go to the categories page
    Then I should see an empty table listing

  Scenario: Collectors cannot create new categories
    Given I am a collector who has logged into the site
    When I go to the categories page
    Then I should not see the link "New Category"

  Scenario: Auditors cannot create new categories
    Given I am a auditor who has logged into the site
    When I go to the categories page
    Then I should not see the link "New Category"

  Scenario: View existing categories
    Given I am a collector who has logged into the site
    And the following valid category exists:
      | French    |
      | Assurance |
    When I go to the categories page
    Then I should see the table listing:
      | Name      | Icon | Total POI | New | Corrected | Invalid | Audited | Field Checked |
      | Assurance |      | 0         | 0   | 0         | 0       | 0       | 0             |

  Scenario: Auditors cannot edit categories
    Given I am a auditor who has logged into the site
    And the following valid category exists:
      | French    |
      | Assurance |
    When I go to the categories page
    Then I should not be able to edit "Assurance" in the table listing

  Scenario: Collectors cannot edit categories
    Given I am a collector who has logged into the site
    And the following valid category exists:
      | French    |
      | Assurance |
    When I go to the categories page
    Then I should not be able to edit "Assurance" in the table listing

  Scenario: Auditors cannot delete categories
    Given I am a auditor who has logged into the site
    And the following valid category exists:
      | French    |
      | Assurance |
    When I go to the categories page
    Then I should not be able to edit "Assurance" in the table listing

  Scenario: Collectors cannot delete categories
    Given I am a collector who has logged into the site
    And the following valid category exists:
      | French    |
      | Assurance |
    When I go to the categories page
    Then I should not be able to edit "Assurance" in the table listing
    
  Scenario: Administrators can create new categories
    Given I am a administrator who has logged into the site
    And the following valid category exists:
      | French    |
      | Assurance |
    When I go to the categories page
    Then I should see the link "New Category"

  Scenario: Administrators can edit categories
    Given I am a administrator who has logged into the site
    And the following valid category exists:
      | French    |
      | Assurance |
    When I go to the categories page
    Then I should be able to edit "Assurance" in the table listing

  Scenario: Administrator can delete categories
    Given I am a administrator who has logged into the site
    And the following valid category exists:
      | French    |
      | Assurance |
    When I go to the categories page
    Then I should be able to delete "Assurance" in the table listing