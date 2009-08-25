require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationController do

  it "should redirect to the iPhoneApp if the user agent is Mobile Safari" do
    request.user_agent = "Mobile Safari"
    
    get "/"
    
    response.should redirect_to("/donations")
  end
  
  it "should not redirect to the iPhoneApp if the session says not to" do
    session["full_site"] = true
    
    get '/'
    
    response.should be_success
  end

end
