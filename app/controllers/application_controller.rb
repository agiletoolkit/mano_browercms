# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :redirect_to_iphone

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def redirect_to_iphone
    if iphone_user?
      if (CONFIG[:use_ssl_for_donations])
        redirect_to(:controller => 'donations', :protocol => "https")  unless (session['full_site'] )
      else
        redirect_to(:controller => 'donations')  unless (session['full_site'] )
      end
    end
  end
  
  
  protected ###############################################
  
  def iphone_user?
    return request.user_agent.match(/iPhone.+Mobile.+Safari/)
  end
end