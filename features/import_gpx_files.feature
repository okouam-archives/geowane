Feature: Import locations from GPX
  As an auditor
  In order to add POI to the database
  I want to import locations from a GPX file

  Background:
    Given I am a auditor with login "johnson" who has logged into the site
    And I go to the imports page
    And I follow "New Import"

  Scenario: Import a file containing valid locations
    When I attach the file "sample.gpx" from the folder "spec/samples" for "Data File"
    And I press "Process File"
    Then I should see the table listing:
      || ID  | Name | Longitude  | Latitude  |
      || NEW | 252  | -3.7318655 | 5.2135383 |

  Scenario: Apply changes from the imported file
    When I attach the file "sample.gpx" from the folder "spec/samples" for "Data File"
    And I press "Process File"
    And I check "252"
    And I follow "Apply Updates"
    Then I should see the table listing:
      | Input File | Locations Imported | User    |
      | sample.gpx | 1                  | johnson |

  Scenario: Omit selecting a file from which to import
    When I press "Process File"
    Then I should see the error message "n'est pas valide et must be set."

  Scenario: Show user as the default author of the file
    Then I should see "johnson" as "Author"

  Scenario: Import from an unknown file type
    When I attach the file "spec_helper.rb" from the folder "spec" for "Data File"
    And I press "Process File"
    Then I should see the inline error message "n'est pas valide et must be set."

  Scenario: Import from a file that cannot be found 
    When I attach the file "spec_helper.rb" from the folder "XXXX" for "Data File"
    And I press "Process File"
    Then I should see the error message "The file you selected could not be found."
