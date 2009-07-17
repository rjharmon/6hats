
Feature: Topic stages
  In order to make it easy to capture my thoughts
  As a user
  I want to be guided to my first few hats for thinking

  Scenario: Creating todo steps
    Given I am logged in
    When I create a new topic
    Then a topic_stage should exist with topic: that topic, hat: blue
    When I go to that topic's show page
#'
    Then a user_topic_stage should exist with topic_stage: that topic_stage, topic: that topic, user: me, state: open
    
  Scenario Outline: Initial Blue Hat activities
    Given I have started a topic in the Blue Hat
    And   I should understand that "understood" offers only 20/40/60/80/100 options
    And   I should undersatnd that "emotion" offers only 10/30/50/70/90 options
    And   I should understand that we want
    When  I enter "<understood>" for outcomes_understood
    And   I enter "<emotion>" for emotional_content
    Then  A topic_stage with hat:'<stage1>' should exist
    And   That topic_stage should come first
    And   A topic_stage with hat:'<stage2>' should <not> exist
    
    # red = 0 unless red > 50
    # white = 0 if white < 25
    # blue  = 0 if blue  < 25  
    # throw away anything now at 0
    # sort descending by number
    # throw away third item, if any
    # add green (general) on end
    # add yellow (todo items generated in green) on end
    # add black  (todo items generated in green) on end
    # add blue   (organization, general) to sort black items
  
    Examples:
    | understood | emotion | stage1 | stage2 | not | !understood |
    | 20         | 10      | white  | not    | not | 80          |
    | 40         | 10      | white  | blue   |     | 60          |
    | 60         | 10      | white  | blue   |     | 40          | 
    | 80         | 10      | blue   | not    | not | 20          |
    | 100        | 10      | blue   | not    | not | 0           |
    | 20         | 30      | white  | not    | not | 80          |
    | 40         | 30      | white  | blue   |     | 60          |
    | 60         | 30      | white  | blue   |     | 40          |
    | 80         | 30      | blue   | not    | not | 20          |
    | 100        | 30      | blue   | not    | not | 0           |
    | 20         | 50      | white  | not    | not | 80          |
    | 40         | 50      | white  | blue   |     | 60          |
    | 60         | 50      | blue   | white  |     | 40          |
    | 80         | 50      | blue   | not    | not | 20          |
    | 100        | 50      | blue   | not    | not | 0           |
    | 20         | 70      | white  | red    |     | 80          |
    | 40         | 70      | red    | white  |     | 60          |
    | 60         | 70      | red    | blue   |     | 40          |
    | 80         | 70      | blue   | red    |     | 20          |
    | 100        | 70      | blue   | red    |     | 0           |
    | 20         | 90      | red    | white  |     | 80          |
    | 40         | 90      | red    | white  |     | 60          |
    | 60         | 90      | red    | blue   |     | 40          |
    | 80         | 90      | red    | blue   |     | 20          |
    | 100        | 90      | red    | blue   |     | 0           |

  Scenario Outline: Mid-Topic Organizational activities in the Blue Hat
    Given I have finished black-hatting my green thoughts
    When I proceed to the blue hat
    Then I should be able to sort my black hat thoughts
  
