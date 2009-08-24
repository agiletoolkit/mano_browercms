require "step_defiintions/webrat_steps"

Feature: Redirect to iPhone Version of App
  In order Make it simple to donate
  As a iPhone Donator
  I want to go straight to the iPhone version of the site

Scenario: Default page redirects to iPhone site
  Given an iPhone request
	When  I go to the homepage
	Then  I should go to /donations




  
