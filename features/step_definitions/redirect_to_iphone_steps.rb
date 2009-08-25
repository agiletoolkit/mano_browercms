Given /^an iPhone request$/ do
  header("User-agent", "Mobile Safari")
end

Given /^a homepage/ do
  group = Group.create!(:code => "guest", :name => "guest_group")
  section = group.sections.create(:name => "Name", :path => "/")

  page = Page.create!(:path => '/', :name => "homepage")  
  section_node = page.create_section_node
  section_node.section = section

  section_node.save!
  page.publish
end

Given /^a standard web request$/ do
  header("User-agent", "Safari")
end
