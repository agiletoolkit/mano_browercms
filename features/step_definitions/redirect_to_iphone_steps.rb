Given /^an iPhone request$/ do
  header("User-agent", "Mobile Safari")
end

Given /^a standard web request$/ do
  header("User-agent", "Safari")
end
