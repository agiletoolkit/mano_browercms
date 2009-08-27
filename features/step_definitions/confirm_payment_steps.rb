Given /^a confirmation request$/ do
  header("User-agent", "Mobile Safari")
  visit("/cms/payments/receipt?first_name=Brian&custom=roads&payment_gross=25&payer_email=brian@briansco.com")
end

When /^print$/ do
  puts response.body #}"$browser.html: {$browser.html}"
end