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
      redirect_to(:controller => 'donations', :action => 'index', :protocol => 'https://' )  unless (session['full_site'] )
    end
  end
  
  def redirect_to_ssl
    if request.ssl? || local_request?
      return true
    else
      redirect_to url_for params.merge({:protocol => 'https://'})
      return false
    end
  end
  
  protected ###############################################
  
  def iphone_user?
    return request.user_agent.match(/Mobile.+Safari/)
  end
end


def redirect_to_ssl
  if request.ssl? || local_request?
    return true
  else
    redirect_to url_for params.merge({:protocol => 'https://'})
    return false
  end
end