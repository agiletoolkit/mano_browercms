class DonationsController < ApplicationController
  layout "donation"
  acts_as_iphone_controller
  skip_before_filter :redirect_to_iphone
  
  def view_full_site
    session["full_site"] = true
    redirect_to cms_home_url
  end  
end
