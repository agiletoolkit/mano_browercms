require File.dirname(__FILE__) + '/../spec_helper'

describe PaypalClient, "attempt" do
  before(:each) do
    @credit_card = mock("credit_card")
    @billing_address = mock("billing_address")
    @paypal_client = PaypalClient.new(@credit_card, @billing_address)
  end
  
  it "should have a nil transaction_id before attempt" do
    @paypal_client.transaction_id.should be_nil
  end
  
  describe "with a valid credit card" do
    before(:each) do
      @credit_card.stub!(:valid?).and_return(true)
      @authorization = mock("authorization")
      @response = mock("response", :success? => nil, :authorization => @authorization)
      @gateway = mock("PaypalGateway", :authorize => @response, :capture => nil)
      ActiveMerchant::Billing::PaypalGateway.stub!(:new).and_return(@gateway)
    end
      
    it "should use the a payment gateway credentials from the config" do
      gateway_credentials = mock("gateway_credentials")
      CONFIG[:gateway_credentials] = gateway_credentials
      
      ActiveMerchant::Billing::PaypalGateway.should_receive(:new).with(gateway_credentials).and_return(@gateway)
      
      @paypal_client.attempt(5000)                                                            
    end
    
    it "should authorize the credit card on the gateway" do
      @gateway.should_receive(:authorize).with(5000, @credit_card, anything()).and_return(@response)
      
      @paypal_client.attempt(5000)
    end
    
    it "should get the price from config" do
      @gateway.should_receive(:authorize).with(10000, @credit_card, anything()).and_return(@response)
      @paypal_client.attempt(10000)                                                            
    end
    
    it "should pass a billing address to authorize the credit card" do
      @gateway.should_receive(:authorize).with(anything(), anything(), {:billing_address => @billing_address, :ip => ''}).and_return(@response)
      
      @paypal_client.attempt(5000)                                                            
    end
    
    describe "successful authorization" do
      before(:each) do
        @response.stub!(:success?).and_return(true)
        @capture_result = mock("capture_result", :params => {})
        @gateway.stub!(:capture).and_return(@capture_result)
      end
    
      it "should capture the money if the authorization if successful" do
        @gateway.should_receive(:capture).with(45454, @authorization).and_return(@capture_result)
      
        @paypal_client.attempt(45454)                                                            
      end
    
      it "should return true is the authorization was successful" do
        @paypal_client.attempt(5000).should be_true
      end
      
      it "should get the transaction_id from the gateway" do
        @capture_result.should_receive(:params).and_return({'transaction_id' => "123ABC"})
        
        @paypal_client.attempt(5000)                                                            
        
        @paypal_client.transaction_id.should == "123ABC"
      end
    end
    
    it "should return false is the authorization was unsuccessful" do
      @response.stub!(:success?).and_return(false)
      
      @paypal_client.attempt(5000).should be_false
    end
    
    it "should not capture the money if the authorization is unsuccessful" do
      @response.stub!(:success?).and_return(false)
      @gateway.should_not_receive(:capture)
      
      @paypal_client.attempt(5000)                                                            
    end
    
  end
  
  describe "with a invalid credit card" do
    before(:each) do
      @credit_card.stub!(:valid?).and_return(false)
    end
    
    it "should return false on attempt" do
      @paypal_client.attempt(5000).should be_false
    end
    
    it "should not create the payment gateway" do
      ActiveMerchant::Billing::PaypalGateway.should_not_receive(:new)
      
      @paypal_client.attempt(5000)                                                            
    end
  end
end
