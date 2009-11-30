Feature: dot progress
  In order to keep track of long-running tasks
  As a task-runner
  I want to see the progress visually

  Scenario: Display dots
    Given an array [1, 2, 3, 4, 5]
    When I run it with dots
    Then I should see 5 "." dots
    And I should see 0 "F" dots
    And I should see 0 "E" dots
    And I should see how long it took
    And I should not see "Failure"
    And I should not see "Error"
    And I should see "5 total, 5 passed, 0 failed, 0 erred"

  Scenario: Display failures
    Given an array [1, 2, 3, 4, 5]
    When I don't want 3s
    And I run it with dots
    Then I should see 4 "." dots
    And I should see 1 "F" dot
    And I should see 0 "E" dots
    And I should see how long it took
    And I should see ") Failure" 1 time
    And I should not see ") Error"
    And I should see "No threes!"
    And I should see the exception's line number
    And I should see "<3>"
    And I should see "5 total, 4 passed, 1 failed, 0 erred"

  Scenario: Display errors
    Given an array [1, 2, 3, 4, 5]
    When I divide each by zero
    And I run it with dots
    Then I should see 5 "E" dots
    And I should see 0 "." dots
    And I should see 0 "F" dots
    And I should see how long it took
    And I should see ") Error" 5 times
    And I should see "ZeroDivisionError: divided by 0" 5 times
    And I should see the exception's line number
    And I should not see "Failure"
    And I should see "5 total, 0 passed, 0 failed, 5 erred"

  Scenario: Constant dots
    Given a task that takes 5 seconds
    When I run it in a dots block
    Then I should see 5 "." dots
