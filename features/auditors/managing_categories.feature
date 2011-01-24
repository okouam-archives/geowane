Feature: Manage categories
  As an auditor
  In order to categorize locations
  I want to manage categories

  Scenario: Add a new category
    Given I am a auditor who has logged into the site
    When I go to the categories page
    And I follow "New Category"
    And I fill in "French" with "Magasins"
    And I fill in "English" with "Shops"
    And I press "Create Category"
    Then I should see in the categories list:
      |0-One    | Locations |
      |Magasins | 0         |

  Scenario: Edit a category
    Given I am a auditor who has logged into the site
    And the following valid category exists:
      | French    |
      | Assurance |
    When I go to the categories page
    And I follow "Edit" for "Assurance"
    And I fill in "French" with "Base militaire"
    And I press "Update Category"
    Then I should see in the categories list:
      |0-One          | Locations |
      |Base militaire | 0         |

  Scenario: Delete a category
    Given I am a auditor who has logged into the site
    And the following valid categories exists:
      | French    |
      | Assurance |
      | Magasin   |
    When I go to the categories page
    And I follow "Delete" for "Assurance"
    Then I should see in the categories list:
      | 0-One   |
      | Magasin |

  Scenario: Update a category

  Scenario: Change the icon for a category