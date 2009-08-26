# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

CONFIG = {}
CONFIG[:use_ssl_for_donations] = false
CONFIG[:gateway_credentials] = {
    :login => "manoamano_api1.manoamano.org",
    :password => "4HUTGJ628ZQJYJ5T",
    :signature => "A84OPQHyR9Id2LfVKRBUe313HvA9A37FdmAUhqf1DZO.1u.Q490Ct5DX5"
}

#Set the site domain so that errors don't pop up when you assign tasks in 
#browsercms: reported in lighthouse bug #146
SITE_DOMAIN="localhost:3000"