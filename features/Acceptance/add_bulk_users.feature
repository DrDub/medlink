# @focus
Feature: Add Bulk Users
  As an admin to the website
  I want to be able to add bulk users
  So that they can use the system

  Background:
    Given I am logged in as an admin
    And that "Senegal" is a country
    And that "Chad" is a country
    And that the following pcmos exist:
      | name    | country |
      | patrick | Senegal |
      | ricky   | Chad    |
    When  I go to the add user page

######################################################################
#SUNNY

  Scenario: Upload CSV Touch test
    Then I should see the add user form
    Then I should see the button "Upload CSV"
    Then I should see browse button "csv"

#----------------------------------------------------------------------
# GOOD + OVERWRITE

  # Assuming 3 initial users and adding 1 PCV user
  Scenario: GOOD: Successfully selecting a file with OVERWRITE and uploading 1 good PCV user
    When I check on "overwrite"
    When I upload a csv file "users_csv_1_good_pcv.csv" with all valid data
    Then I should not download anything invalid
    Then the number of users should change to 4
    And I should sent to the add user page

  # Assuming 3 initial users and adding 1 PCMO user
  Scenario: GOOD: Successfully selecting a file with OVERWRITE and uploading 1 good PCMO user
    When I check on "overwrite"
    When I upload a csv file "users_csv_1_good_pcmo.csv" with all valid data
    Then I should not download anything invalid
    Then the number of users should change to 4
    And I should sent to the add user page

  # Assuming 3 initial users and adding 1 ADMIN user
  Scenario: GOOD: Successfully selecting a file with OVERWRITE and uploading 1 good ADMIN user
    When I check on "overwrite"
    When I upload a csv file "users_csv_1_good_admin.csv" with all valid data
    Then I should not download anything invalid
    Then the number of users should change to 4
    And I should sent to the add user page

#----------------------------------------------------------------------
# GOOD + NO OVERWRITE

  # Assuming 3 initial users and adding 1 PCV user
  Scenario: GOOD: Successfully selecting a file with OVERWRITE and uploading 1 good PCV user
    When I uncheck on "overwrite"
    When I upload a csv file "users_csv_1_good_pcv.csv" with all valid data
    Then I should not download anything invalid
    Then the number of users should change to 4
    And I should sent to the add user page

  # Assuming 3 initial users and adding 1 PCMO user
  Scenario: GOOD: Successfully selecting a file with OVERWRITE and uploading 1 good PCMO user
    When I uncheck on "overwrite"
    When I upload a csv file "users_csv_1_good_pcmo.csv" with all valid data
    Then I should not download anything invalid
    Then the number of users should change to 4
    And I should sent to the add user page

  # Assuming 3 initial users and adding 1 ADMIN user
  Scenario: GOOD: Successfully selecting a file with OVERWRITE and uploading 1 good ADMIN user
    When I uncheck on "overwrite"
    When I upload a csv file "users_csv_1_good_admin.csv" with all valid data
    Then I should not download anything invalid
    Then the number of users should change to 4
    And I should sent to the add user page

#----------------------------------------------------------------------
# GOOD + OVERWRITE + DUPLICATE

  # Handling duplicate users.
  Scenario: GOOD: Successfully handle the same user multiple times (both OVERWRITE).
    When I check on "overwrite"
    When I upload a csv file "users_csv_1_good_pcmo.csv" with all valid data
    Then I should not download anything invalid
    And I should sent to the add user page

    When I check on "overwrite"
    When I upload a csv file "users_csv_1_good_pcmo.csv" with all valid data
    Then I should not download anything invalid
    Then the number of users should change to 4
    And I should sent to the add user page

  # Handling duplicate users.
  Scenario: GOOD: Successfully handle the same user multiple times. (both NO OVERWRITE)
    When I uncheck on "overwrite"
    When I upload a csv file "users_csv_1_good_pcmo.csv" with all valid data
    Then I should not download anything invalid
    And I should sent to the add user page

    When I uncheck on "overwrite"
    When I upload a csv file "users_csv_1_good_pcmo.csv" with all valid data
    Then I should not download anything invalid
    Then the number of users should change to 4
    And I should go back to the add user upload page

#----------------------------------------------------------------------
#RAINY

  Scenario: Handle Empty File
    When I upload a csv file with empty file
    Then I should download an error file with bad data and error messages
    Then the number of users should not change
    And I should sent to the add user page

  Scenario: Handle file without header (1st) line
    When I upload a csv file with missing header
    Then I should download an error file with bad data and error messages
    Then the number of users should not change
    And I should sent to the add user page

  Scenario: NONE: Succcesfully selecting a file and uploading all bad data
    When I upload a csv file with all bad user data
    Then I should download an error file with bad data and error messages
    Then the number of users should not change
    And I should go back to the add user upload page

  Scenario: Click on "Upload CSV" before selecting a file
    Then I should see the add user form
    When I click "Upload CSV"
    Then I should see a choose csv file first error message
    And I should sent to the add user page
