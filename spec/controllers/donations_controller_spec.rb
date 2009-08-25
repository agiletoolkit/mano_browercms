require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DonationsController, "routes" do
  
  it "should route to donations ignoring cms" do
    route_for(:controller => "donations", :action => "index").should == "/donations"
  end
  
end

describe DonationsController do
  before(:each) do
    request.user_agent = "Mobile Safari"
  end
  
  it "should set the session for full_site on view_full_site" do
    post :view_full_site
    
    session["full_site"].should be_true
  end
  
  it "should redirect to the root" do
    post :view_full_site
    
    response.should redirect_to(cms_home_url)
  end

end
