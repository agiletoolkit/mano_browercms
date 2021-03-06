# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

# Use SQL instead of Active Record's schema dumper when creating the test database.
# This is necessary if your schema can't be completely dumped by the schema dumper,
# like if you have constraints or database-specific column types
# config.active_record.schema_format = :sql

CONFIG = {}
CONFIG[:use_ssl_for_donations] = false

require "active_merchant"
ActiveMerchant::Billing::Base.mode = :test
# must be a Sandbox account to test using Paypal 
CONFIG[:gateway_credentials] = {
  :login => "colin_1238600447_biz_api1.8thlight.com",
  :password => "1238600454",
  :signature => "AFcWxV21C7fd0v3bYYYRCpSSRl31AXhz1eU1BJpGgz0Kb2dDocZQP04t"
}
CONFIG[:paypal_email] = "colin@8thlight.com"

#Set the site domain so that errors don't pop up when you assign tasks in 
#browsercms: reported in lighthouse bug #146
SITE_DOMAIN="codegreenlab.com"
