Feature: Redirect to iPhone Version of App
  In order Make it simple to donate
  As a iPhone Donator
  I want to go straight to the iPhone version of the site

Scenario: Default page redirects to iPhone site
  Given an iPhone request
  And a homepage
	When  I go to the homepage
	Then  I should be on /donations
	
Scenario: Default page does not redirect to iPhone site
  Given a standard web request
	And a homepage
  When I go to the homepage
  Then I should be on the homepage

Scenario: iPhone Page allows you to go back to the standard site
  Given an iPhone request
  When I go to the homepage
  And I follow standard_site_link
	Then I should be on the homepage