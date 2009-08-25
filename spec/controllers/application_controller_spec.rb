require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationController do

  it "should redirect to the iPhoneApp if the user agent is Mobile Safari" do
    request.user_agent = "Mobile Safari"
    
    get "/"
    
    response.redirect_url.include?("/donations").should == true
  end
  
  it "should not redirect to the iPhoneApp if the session says not to" do
    session["full_site"] = true
    
    get '/'
    
    response.should be_success
  end
  
  it "should not redirect to the iPhone app if the user agent does not match mobile safari" do
    request.user_agent = "Wicked Safari"
    
    get "/"
    
    response.should be_success
  end
  
  it "should work with any varation of the user agent" do
    request.user_agent = "Mobile   Safari   2.8"
    
    get "/"
    
    response.redirect_url.include?("/donations").should == true
  end

  it "should redirect to ssl for mobile safari" do
    request.user_agent = "Mobile   Safari   2.8"
    
    get "/"

    response.redirect_url.include?("https://").should == true
  end
  
  it "should redirect even if the word Mobile isn't first in the user agent" do
    request.user_agent = "     Mobile   Safari   2.8"
    
    get '/'
    
    response.redirect_url.include?("/donations").should == true
  end
  

end
