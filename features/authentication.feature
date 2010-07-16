Feature: Authentication
  User should authenticate so that they can pay valuable conference items

  Scenario: I should complete registration with email and password confirmation challenge
    Given I am not authenticated
    When I go to register
    When I fill in "user_email" with "thierry.henrio@gmail.com"
      And I fill in "user_password" with "devise_rocks"
      And I fill in "user_password_confirmation" with "devise_rocks"
      And I press "user_submit"
    Then I should see "Signed in as thierry.henrio@gmail.com"

  @failed
  Scenario: I should sign in using email and password
    Given I am not authenticated
    When I go to the user session page
    When I fill in "user_email" with "thierry.henrio@gmail.com"
      And I fill in "user_password" with "devise_rocks"
      And I press "user_submit"
    Then show me the page
      And I should see "Signed in as thierry.henrio@gmail.com"