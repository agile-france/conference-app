Feature: Authentication
  User should authenticate so that participants trust in proposed sessions

  Scenario: I should complete registration with email and password confirmation challenge
    Given I am not authenticated
    When I go to "/users/sign_up"
      And I fill in "user_email" with "thierry.henrio@gmail.com"
      And I fill in "user_password" with "devise_rocks"
      And I fill in "user_password_confirmation" with "devise_rocks"
      And I validate "#user_new" form
    Then I should see "Bonjour thierry.henrio@gmail.com"
      And I should be on "/account/edit"

  Scenario: I should sign in using email and password
    Given I have one user "gitster@git.org" with password "git rocks"
    When I go to the "/users/sign_in"
      And I fill in "user_email" with "gitster@git.org"
      And I fill in "user_password" with "git rocks"
      And I validate "#user_new" form
    Then I should see "Bonjour gitster@git.org"