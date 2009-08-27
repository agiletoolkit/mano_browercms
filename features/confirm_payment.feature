Feature: Confirm Payment page displays confirmation information
  In order assure the payment has been processed
  As a iPhone Donator
  I want to see a confirmation page

Scenario: Donations Page displays
  Given a confirmation request
  And a homepage
  When print
  Then I should see "Thank"
	And I should see "Brian"
	And I should see "roads"
	And I should see "25"
	And I should see "brian@briansco.com"
	And I follow "Visit Mano a Mano"
		Then I should be on the homepage
	
	