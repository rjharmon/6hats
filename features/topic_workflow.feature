Feature: Topic workflow
  In order to easily express my thoughts within the hats framework
  As an individual user
  I want to be led through the thought process
  
  Background:
    Given an individual user
    
  Scenario: Making a new topic when I first log in
    Given that I have no topics
    When I go to the topics page
    Then I should see a notice message "You don't have any topics yet.  Create a new one here."
     And the 'name' field should have focus
    When I fill in 'name' with 'My First Topic'
     And I press Create
    Then I should have 1 topic with name: 'My First Topic', state: "Explore Emotions"
     And I should be at a page matching topics/[0-9]+/thinking
     And I should see "Explore Emotions"

  Scenario: Initial Exploration of Emotions
    Given that have a topic with name: 'My First Topic'
     When I visit my topic's thinking page
     Then I should see "Explore Emotions"
     When I fill in the form
     Then I should be able to add 3 emotions to the mix
      And their first field should be focused each time
      And see them displayed
     When I follow "Next: Define the Problem"
     Then the topic should have state: "Define the Problem"
      And I should see "Define the Problem"
           
  Scenario: Skipping Exploration of Emotions
    Given that have a topic with name: 'My First Topic'
     When I visit my topic's thinking page
      And I follow "Next: Define the Problem"
     Then the topic should have state: "Define the Problem"
      And I should see "Define the Problem"
      
  Scenario: Finish Defining the Problem
    Given that I have a topic with name: 'My First Topic'
     When I visit my topic's thinking page
      And I follow "Next: Define the Problem"
     Then I should be at the topic's thinking page
     When I fill in some markdown in the description
      And press Save
     Then I should be at the topic's thinking page
      And the topic should have state: "Green"
      And I should see "Possible Solutions"
     
  Scenario: Ability to switch to any hat at any time
  Scenario: Automatic Creation of Expected follow-on thoughts