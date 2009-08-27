require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "index" do
  before(:each) do
    render :template => "/donations/index.iphone.erb"
  end
  
  it "should have a custom field" do
    response.should have_tag("input[type=hidden][name=custom][id=causes]")
  end
  
  it "should have a donation amount" do
    response.should have_tag("input[type=text][name=amount][readonly=readonly]")
  end
end