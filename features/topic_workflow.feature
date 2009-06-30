Feature: Topic workflow
  In order to easily express my thoughts within the hats framework
  As an individual user
  I want to be led through the thought process
      
  Scenario: Making a new topic when I first log in
    Given I'm logged in
    And   I have no topics
    When  I go to the topics page
    Then  I should see a notice message "You don't have any topics yet.  Create a new one here."
    When  I fill in the new topic form
    Then  I should have 1 topic with name: 'My First Topic', state: "Explore Emotions"
    And   I should see "Explore Emotions"


  Scenario: Skipping Exploration of Emotions
    Given I'm logged in
    And   I have a topic with name: 'My First Topic'
    When  I visit my topic's thinking page
    And   I submit the empty form
    Then  the topic should have state: "Define the Problem"
    And   I should see "Define the Problem"


  Scenario: Initial Exploration of Emotions
    Given I'm logged in
    And   I have a topic with name: 'My First Topic'
    When  I visit my topic's thinking page
    Then  I should see "Explore Emotions"
    When  I fill in the Red Hat form
    Then  I should see the new thought on the page
    When  I fill in the Red Hat form
    Then  I should see the new thought on the page
    When  I submit the empty form
    Then  the topic should have state: "Define the Problem"
    And   I should see "Define the Problem"
           
      
  Scenario: Start creating ideas
    Given I'm logged in
    And   I have a topic with name: 'My First Topic' and summary: 'Summary Text'
    Then  the topic should have state: "Green"
    When  I visit my topic's thinking page
    Then  I should see "Possible Solutions"
    
    When  I fill in the Green Hat form with "get a cat"
    Then  I should see the new thought on the page

    When  I fill in the Green Hat form with "get a bird"
    Then  I should see the new thought on the page
    When  I submit the empty form
    Then  the topic should have state: "Yellow"

    And   I should see "Positive thinking"
    And   I should see "get a cat" in the body
    And   I should see "get a cat" in the sidebar
    And   I should see "get a bird" in the sidebar

    When  I fill in the Yellow Hat form with "friends for Kitty and Pixie"
    Then  I should see the new thought on the page
    And   I should see "get a cat (1)" in the sidebar
    When  I submit the empty form
    Then  the topic should have state: "Yellow"
    And   I should see "get a bird" on the page
    
    When  I fill in the Yellow Hat form with "birdy music in the house"
    And   I should see "get a cat (1)" in the sidebar
    And   I should see "get a bird (1)" in the sidebar
    When  I fill in the Yellow Hat form with "entertainment for kitties"
    Then  I should see the new thought on the page
    And   I should see "get a bird (2)" in the sidebar
    And   I should see "get a cat (1)" in the sidebar

    When  I submit the empty form
    Then  the topic should have state: "Black"
    Then  I should see "Arguments against"
    And   I should see "get a cat" in the body
    And   I should see "get a cat" in the sidebar
    And   I should see "get a bird" in the sidebar

    When  I follow "get a bird"
    Then  I should see "get a bird" in the body
    And   I should see "get a cat" in the sidebar
    And   I should see "get a bird" in the sidebar
    When  I fill in the Black Hat form with "Noisy"
    Then  I should see the new thought on the page
    And   I should see "get a cat" in the sidebar
    And   I should see "get a bird (1)" in the sidebar

    When  I submit the empty form
    Then  I should see "get a cat" in the body
    And   I should see "get a cat" in the sidebar
    And   I should see "get a bird (1)" in the sidebar
    
    When  I fill in the Black Hat form with "extra expense"
    Then  I should see the new thought on the page
    And   I should see "get a cat (1)" in the sidebar
    When  I fill in the Black Hat form with "hairballs"
    Then  I should see the new thought on the page
    And   I should see "get a cat (2)" in the sidebar

    When  I submit the empty form
    Then  the topic should have state: "White"
    And   I should see "Information needed"
    And   I should see "Noisy" on the page
    And   I should see "extra expense" in the sidebar
    And   I should see "hairballs" in the sidebar
    And   I should see "Noisy" in the sidebar
    
    When  I submit the empty form
    Then  the topic should have state: "White"
    And   I should see "extra expense" on the page
    When  I fill in the White Hat form with "cost estimation"
    Then  I should see the new thought on the page
    When  I submit the empty form
    Then  I the topic should have state: "White"
    And   I should see "hairballs" on the page
    And   I should see "extra expense (1)" in the sidebar
    And   I should see "hairballs" in the sidebar
    And   I should see "Noisy" in the sidebar
    When  I submit the empty form
    
    Then  the topic should have state: "Green"
    And   I should see "extra expense" in the sidebar
    And   I should see "hairballs" in the sidebar
    And   I should see "extra expense" on the page
    When  I submit the empty form
    Then  I should see "hairballs" on the page
    When  I submit the empty form
    Then  the topic should have state: "Red"
    
    When  I submit the empty form
    Then  the topic should have state: "White"
    And   I should see "cost estimation" on the page
    When  I submit the empty form
    Then  the topic should have state: "Blue"
    And   I should see all the topic's thoughts on the page
    
    
    # from http://midsolutions.org/courses/cis230/ThinkingHats/index.htm
  Scenario: Checking White hat thoughts for emotions or beliefs
  Scenario: Fact-checking White hat thoughts
  Scenario: White hat thoughts might be information needed

  Scenario: red hat emotions

    http://en.wikipedia.org/wiki/List_of_emotions
    http://www.guidetopsychology.com/emotions.htm
    http://changingminds.org/explanations/emotions/basic%20emotions.htm
  

    
  Scenario: Ability to switch to any hat at any time
  
  