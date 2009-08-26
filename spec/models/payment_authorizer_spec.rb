require File.dirname(__FILE__) + '/../spec_helper'

describe PaymentAuthorizer do
  before(:each) do
    CONFIG ||= {}
    @payment_authorizer = PaymentAuthorizer.new({:first_name => "Eric", :last_name => "Meyer", :credit_card_number => "4111111111111111",
                                                 :expiration_month => "4", :expiration_year => "2019", :card_security_code => "123", :email_address => "eric@meyer.com",
                                                 :address_line_one => "123 Cattle Drive", :city => "Libertyville", :state => "IL", :zip => 60048, :country => "US"})
    @credit_card = mock("credit_card", :valid? => nil)
    ActiveMerchant::Billing::CreditCard.stub!(:new).and_return(@credit_card)
  end

  it "should be valid with all the params" do
    @payment_authorizer.should be_valid
  end
  
  it "should handle no params on init" do
    lambda{PaymentAuthorizer.new}.should_not raise_error
  end
  
  it "should have a first and last name" do
    @payment_authorizer.first_name.should == "Eric"
    @payment_authorizer.last_name.should == "Meyer"
  end
  
  it "should have a full name" do
    @payment_authorizer.full_name.should == "Eric Meyer"
  end
  
  it "should require the first_name" do
    @payment_authorizer.first_name = nil
    @payment_authorizer.should_not be_valid
    @payment_authorizer.errors.should_not be_empty
  end
  
  it "should require the last_name" do
    @payment_authorizer.last_name = nil
    @payment_authorizer.should_not be_valid
    @payment_authorizer.errors.should_not be_empty    
  end
  
  it "should require the card number" do
    @payment_authorizer.credit_card_number = nil
    @payment_authorizer.should_not be_valid
    @payment_authorizer.errors.should_not be_empty    
  end

  it "should make sure the credit_card_number is a number" do
    @payment_authorizer.credit_card_number = "ABC"
    @payment_authorizer.should_not be_valid
  end
  
  it "should strip dashes" do
    @payment_authorizer.credit_card_number = "123-123-123"
    @payment_authorizer.credit_card_number.should == "123123123"
    @payment_authorizer.should be_valid
  end
  
  it "should require the expiration month" do
    @payment_authorizer.expiration_month = nil
    @payment_authorizer.should_not be_valid
  end
  
  it "should require the expiration year" do
    @payment_authorizer.expiration_year = nil
    @payment_authorizer.should_not be_valid
  end
    
  it "should require the card_security_code" do
    @payment_authorizer.card_security_code = nil
    @payment_authorizer.should_not be_valid
  end

  it "should make sure the card_security_code is a number" do
    @payment_authorizer.card_security_code = "ABC"
    @payment_authorizer.should_not be_valid
  end
  
  it "should require the address_line_one" do
    @payment_authorizer.address_line_one = nil
    @payment_authorizer.should_not be_valid
  end

  it "should require the city" do
    @payment_authorizer.city = nil
    @payment_authorizer.should_not be_valid
  end

  it "should require the state" do
    @payment_authorizer.state = nil
    @payment_authorizer.should_not be_valid
  end

  it "should require the zip" do
    @payment_authorizer.zip = nil
    @payment_authorizer.should_not be_valid
  end
  
  it "should make sure the zip is a number" do
    @payment_authorizer.zip = "ABCDE"
    @payment_authorizer.should_not be_valid
  end

  it "should require the country" do
    @payment_authorizer.country = nil
    @payment_authorizer.should_not be_valid
  end

  it "should require the email_address" do
    @payment_authorizer.email_address = nil
    @payment_authorizer.should_not be_valid
  end
  
  it "should check the format of the email_address" do
    check_for_invalid_email_address "123"
    check_for_invalid_email_address "@gmail.com"
    check_for_invalid_email_address "eric"
    check_for_invalid_email_address "eric@gmail"
    check_for_invalid_email_address "eric@.com"
    check_for_invalid_email_address "eric@gmail."
    check_for_invalid_email_address "eric@eric@eric.com"
    check_for_valid_email_address "eric@meyer.com"
    check_for_valid_email_address "someone123@else123.net"
    check_for_valid_email_address "123123@1.org"
  end
  
  def check_for_invalid_email_address(email_address)
    @payment_authorizer.email_address = email_address
    @payment_authorizer.should_not be_valid
  end

  def check_for_valid_email_address(email_address)
    @payment_authorizer.email_address = email_address
    @payment_authorizer.should be_valid
  end
  
  describe "attempt" do
    before(:each) do
      @paypal_client = mock("paypal_client", :attempt => nil)
      PaypalClient.stub!(:new).and_return(@paypal_client)
    end
  
    it "should create a credit card object" do
      ActiveMerchant::Billing::CreditCard.should_receive(:new).with({:first_name => "Eric", :last_name => "Meyer", :number => "4111111111111111",
                                                                                :month => "4", :year => "2019", :verification_value => "123"}).and_return(@credit_card)
  
      @payment_authorizer.attempt(1000)
    end
  
    it "should create the paypal client" do
      billing_address = {:name => "Eric Meyer", :address1 => "123 Cattle Drive", :city => "Libertyville", :state => "IL", :zip => 60048, :country => "US"}
      PaypalClient.should_receive(:new).with(@credit_card, billing_address).and_return(@paypal_client)
    
      @payment_authorizer.attempt(1000)
    end
    
    it "should return false if the client returns false" do
      @paypal_client.stub!(:attempt).and_return(false)
      
      @payment_authorizer.attempt(1000).should be_false
    end
  
    it "should have an error if the paypal client returns false" do
      @paypal_client.stub!(:attempt).and_return(false)
      
      @payment_authorizer.attempt(1000)
      @payment_authorizer.errors.should_not be_empty
    end
    
    it "should pass charge down to paypal_client" do
      @paypal_client.should_receive(:attempt).with(777)
      @payment_authorizer.attempt(777)
    end
    
    it "should check if the payment_authorizer is valid on attempt" do
      @payment_authorizer.credit_card_number = nil
      @payment_authorizer.attempt(100).should be_false
      @payment_authorizer.errors.should_not be_empty
    end
    
    describe "returns true" do
      before(:each) do
        @paypal_client.stub!(:attempt).and_return(true)
        @paypal_client.stub!(:transaction_id)
      end
      
      it "should return true if the client returns true" do
        @payment_authorizer.attempt(1000).should be_true
      end
      
      it "should get the transaction id if the attempt is successful" do
        @paypal_client.should_receive(:transaction_id).and_return("123456")
        
        @payment_authorizer.attempt(1000)
        
        @payment_authorizer.transaction_id.should == "123456"
      end
    end 
  end
end