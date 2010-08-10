require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BlogsHelper do
  # include ActionView::Helpers::UrlHelper
  include ActionController::UrlWriter

  #Delete this example and add some real ones or delete this file
  it "should be included in the object returned by #helper" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(BlogsHelper)
  end
  
  it "should summarize a blog entry" do
    entries = [
      BlogPost.new(:body => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", 
                   :name => "jeremy", 
                   :summary => "my title"),
      BlogPost.new(:body => "short body text", :name => "chris", :summary => "his title")
    ]
    
    entries = helper.summarize(entries, 30)
    
    entries[0].name.should == "jeremy"
    entries[0].summary.should == "my title"
    entries[0].body.should == "Lorem ipsum dolor sit amet,..."
    # entries[0].body.should == "Lorem ipsum dolor sit amet,... <a href=\"#{blog_post_path(entries[0].route_params)}\">Read more</a>"
    
    entries[1].name.should == "chris"
    entries[1].body.should == "short body text"
  end
  
  it "should not chop up a tag like an image"
  
  def blog_post_path(route_params)
    "/blog/entry"
  end
end
