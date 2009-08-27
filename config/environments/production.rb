# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true
config.action_controller.page_cache_directory = RAILS_ROOT + "/public/cache/" 

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!

CONFIG = {}
CONFIG[:use_ssl_for_donations] = true
CONFIG[:gateway_credentials] = {
  :login => "manoamano_api1.manoamano.org",
  :password => "4HUTGJ628ZQJYJ5T",
  :signature => "A84OPQHyR9Id2LfVKRBUe313HvA9A37FdmAUhqf1DZO.1u.Q490Ct5DX5"
}

require "active_merchant"
ActiveMerchant::Billing::Base.mode = :test
# CONFIG[:paypal_email] = "manoamano_api1@manoamano.org"
CONFIG[:paypal_email] = "colin_1238600447_biz@8thlight.com"

#Set the site domain so that errors don't pop up when you assign tasks in 
#browsercms: reported in lighthouse bug #146
SITE_DOMAIN="codegreenlab.com"
