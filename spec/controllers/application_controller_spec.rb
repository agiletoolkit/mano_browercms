require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationController do

  it "should redirect to the iPhoneApp if the user agent is iPhone Mobile Safari" do
    request.user_agent = "iPhone Mobile Safari"
    
    get "/"
    
    response.redirect_url.include?("/donations").should == true
  end
  
  it "should not redirect to the iPhoneApp if the session says not to" do
    session["full_site"] = true
    
    get '/'
    
    response.should be_success
  end
  
  it "should not redirect to the iPhoneApp if iPad Mobile Safari" do
    request.user_agent = "iPad Mobile Safari"
    
    get '/'
    
    response.should be_success
  end
  
  it "should not redirect to the iPhone app if the user agent does not match mobile safari" do
    request.user_agent = "Wicked Safari"
    
    get "/"
    
    response.should be_success
  end
  
  it "should work with any varation of the user agent" do
    request.user_agent = "iPhone 1234 Mobile  5678 Safari   2.8"
    
    get "/"
    
    response.redirect_url.include?("/donations").should == true
  end

  it "should redirect to ssl for mobile safari if ssl_enabled" do
    CONFIG[:use_ssl_for_donations] = true
    request.user_agent = "iPhone Mobile   Safari   2.8"
    
    get "/"

    response.redirect_url.include?("https://").should == true
  end

  it "should not redirect to ssl for mobile safari if is not ssl_enabled" do
    CONFIG[:use_ssl_for_donations] = false
    request.user_agent = "iPhone Mobile   Safari   2.8"
    
    get "/"

    response.redirect_url.include?("http://").should == true
  end

  
  it "should redirect even if the word Mobile isn't first in the user agent" do
    request.user_agent = "  iPhone   Mobile   Safari   2.8"
    
    get '/'
    
    response.redirect_url.include?("/donations").should == true
  end
  
  

end
