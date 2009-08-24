Given /^an iPhone request$/ do
  # pending
end

Given /^a homepage/ do
  Page.create!(:path => '/', :published => true, :archived => false, :deleted => :false, :name => "homepage")  
end
