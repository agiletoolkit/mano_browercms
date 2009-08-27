require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PaymentsController do
  before(:each) do
    @payment_authorizer = mock("payment_authorizer", :attempt => nil)
    PaymentAuthorizer.stub!(:new).and_return(@payment_authorizer)
  end

  it "should create the payment_authorizer" do
    PaymentAuthorizer.should_receive(:new).with(HashWithIndifferentAccess.new({:param_one => "value", :year => "2020"})).and_return(@payment_authorizer)
    
    post :attempt, :payment_authorizer => {:param_one => "value"}, :date => {:year => "2020"}
  end

  it "should assign the payment_gateway" do
    post :attempt, :payment_authorizer => {}, :date => {}

    assigns[:payment_authorizer].should == @payment_authorizer
  end

  it "should attempt payment if the donation is greater than 0" do
    @payment_authorizer.should_receive(:attempt).with(5000)

    post :attempt, :payment_authorizer => {}, :date => {}, :donation_amount_in_cents => 5000
  end

  it "should not attempt donation less than 100" do
    @payment_authorizer.should_not_receive(:attempt)

    post :attempt, :payment_authorizer => {}, :date => {}, :donation_amount_in_cents => 98

    assigns[:error_message].should_not be_blank
    response.should render_template("new")
  end

  it "should render the receipt page if the payment is successful" do
    @payment_authorizer.stub!(:attempt).and_return(true)

    post :attempt, :payment_authorizer => {}, :date => {}, :donation_amount_in_cents => 5000

    response.should render_template("receipt")
  end

  it "should render the donations page if the payment is unsuccessful" do
    @payment_authorizer.stub!(:attempt).and_return(false)

    post :attempt, :payment_authorizer => {}, :date => {}, :donation_amount_in_cents => 5000

    response.should render_template("new")
  end

  describe "using Mobile Safari" do
    before(:each) do
      request.user_agent = "Mobile Safari"
    end

    it "should show the proper iPhone view" do
      get :new
    
      response.should render_template("new.iphone.erb")
    end
  
    it "should have a payment authorizer when starting payment" do
      get :new
    
      assigns[:payment_authorizer].should == @payment_authorizer
    end
  end
end

