require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "New" do
  before(:each) do
    render :template => "/payments/new.iphone.erb"
  end
  
  it "should have a custom field" do
    response.should have_tag("input[type=text][name=custom]")
  end
  
  it "should have a donation amount" do
    response.should have_tag("input[type=text][name=amount]")
  end
end