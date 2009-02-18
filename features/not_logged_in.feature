Feature: Publicly-visible content
  In order to get more users
  As an anonymous user
  I want to have access to useful content and resources
  
  Background:
    Given an anonymous user
  
  Scenario: Availability of basic information
    When user goes to the home page
    Then she should be redirected to the hats page
    When she follows that redirect!
    Then she should see 7 'tr' elements showing a brief introduction to the 6 hats
     And she should see a link 'Rules for Thinking' to /hats/rules
     And I should see "Problems of the Argumentative Meeting Style"

  Scenario: Availability of more detailed rules about the hats
    When user goes to hats/rules
    Then she should see an outbound link to the www.amazon.com domain
     And I should see "general guidelines"
     And she should see 6 '.content div.box-body' elements describing the rules of each hat
     
  Scenario: Availability of register and login
    When user goes to the home page 
    Then she should be redirected to the hats page
    When she follows that redirect!
    Then she should see a link 'Log in' to /login
     And she should see a link 'register' to /register
     
  Scenario: No availability of editing hats data
    When user goes to the hats page
    Then she should not see a link to a page matching hats/[0-9+]/edit
     And she should not see a link to a page matching hats/[0-9+]/destroy

    
  Scenario: No availability of editing project data
    When user goes to topics
    Then she should be redirected to the login page
    When she follows that redirect!
    Then she should see a notice message 'Please log in to continue'
  
  
  
  