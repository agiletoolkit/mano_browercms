require "spec"

describe "Paypal Sandbox Gateway" do

  # Called before each example.
  before(:each) do
    @payment_authorizer = PaymentAuthorizer.new({:first_name => "Eric", :last_name => "Meyer", :credit_card_number => "4111111111111111",
                                                    :expiration_month => "4", :expiration_year => "2019", :card_security_code => "123", :email_address => "eric@meyer.com",
                                                    :address_line_one => "123 Cattle Drive", :city => "Libertyville", :state => "IL", :zip => 60048, :country => "US"})
  end

  it "should return true if the client returns true" do
       @payment_authorizer.attempt(1000).should be_true
  end
end