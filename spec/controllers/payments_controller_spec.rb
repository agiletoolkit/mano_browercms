require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PaymentsController do
  before(:each) do
    @payment_authorizer = mock("payment_authorizer", :attempt => nil)
    PaymentAuthorizer.stub!(:new).and_return(@payment_authorizer)
  end

  describe "using Mobile Safari" do
    before(:each) do
      request.user_agent = "Mobile Safari"
    end

    it "should show the proper iPhone view" do
      get :new
    
      response.should render_template("new.iphone.erb")
    end
  end

  describe "when starting payment" do
    it "should have a payment authorizer" do
      get :new

      assigns[:payment_authorizer].should == @payment_authorizer
    end
    
    it "should verify authenticity token" do
      controller.should_receive(:verify_authenticity_token)
      
      get :new
    end
  end
  
  describe "when confirming payment" do
    it "should have a payment authorizer" do
      PaymentAuthorizer.should_receive(:new).and_return(@payment_authorizer)
      
      post :confirm, :payment_authorizer => {:param_one => "value"}
      
      assigns[:payment_authorizer].should == @payment_authorizer
    end
    
    it "should retain the donation amount" do
      post :confirm, :donation_amount_in_dollars => "100"
      
      assigns[:donation_amount_in_dollars].should == "100"
    end
  end
  
  describe "when attempting payment" do
    it "should create the payment_authorizer" do
      PaymentAuthorizer.should_receive(:new).with(HashWithIndifferentAccess.new({:param_one => "value"})).and_return(@payment_authorizer)

      post :attempt, :payment_authorizer => {:param_one => "value"}
    end

    it "should assign the payment_gateway" do
      post :attempt, :payment_authorizer => {}, :date => {}

      assigns[:payment_authorizer].should == @payment_authorizer
    end

    it "should attempt payment if the donation is greater than 0" do
      @payment_authorizer.should_receive(:attempt).with(5000)

      post :attempt, :payment_authorizer => {}, :donation_amount_in_dollars => 5000
    end

    it "should not attempt donation less than 100" do
      @payment_authorizer.should_not_receive(:attempt)

      post :attempt, :payment_authorizer => {}, :donation_amount_in_dollars => 98

      assigns[:error_message].should_not be_blank
      response.should render_template("new")
    end

    it "should render the receipt page if the payment is successful" do
      @payment_authorizer.stub!(:attempt).and_return(true)

      post :attempt, :payment_authorizer => {}, :donation_amount_in_dollars => 5000

      response.should render_template("receipt")
    end

    it "should render the donations page if the payment is unsuccessful" do
      @payment_authorizer.stub!(:attempt).and_return(false)

      post :attempt, :payment_authorizer => {}, :donation_amount_in_dollars => 5000

      response.should render_template("new")
    end
  end
  
  describe "when given reciept from PayPal" do
    it "should not verify authenticity token" do
      controller.should_not_receive(:verify_authenticity_token)
      
      post :receipt
    end
    
    it "should assign payment information" do
      post :receipt, :mc_gross => "100", :payer_email => "test@testing.com", 
                     :first_name => "Test", :last_name => "Testerson", 
                     :custom => "First Cause, Second Cause, Third Cause",
                     :payment_gross => "20.00"

      assigns[:email].should == "test@testing.com"
      assigns[:first_name].should == "Test"
      assigns[:causes].should == "First Cause, Second Cause, Third Cause"
      assigns[:donation_amount_in_dollars].should == "20.00"
    end
  end
  
  describe "when notified by Paypal" do
    it "should not verify authenticity token" do
      controller.should_not_receive(:verify_authenticity_token)
      
      post :notify
    end
  end
end

