Feature: Generating new Rango application
  In order to XXXXXXXXXXXXXX
  As a rango user
  I want to generate new application

  Scenario: Successful
    Given I have installed "thor" executable
    When I run "application" generator
    Then the command should end successfuly
    And it creates directory "my-application"
    And I suspect thor tasks will run
