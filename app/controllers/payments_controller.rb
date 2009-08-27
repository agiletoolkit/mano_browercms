class PaymentsController < ApplicationController
  include ActiveMerchant::Billing::Integrations
  skip_before_filter :redirect_to_iphone
  acts_as_iphone_controller
  
  def new
    @payment_authorizer = PaymentAuthorizer.new
  end
  
  def confirm
    payment_params = params[:payment_authorizer]
    @payment_authorizer = PaymentAuthorizer.new(params[:payment_authorizer])
    @donation_amount_in_cents = params[:donation_amount_in_cents]

    # TODO: CWJ create new model & save off transaction ID, name, email, payment amount.
    #           Perhaps we should change PaymentAuthorizer to this model since it no longer
    #           does any payment processing
  end

  # TODO: CWJ add postback notification action (maybe checking a field in the db on the above model)
  def notify
    
  end
  

  # TODO: CWJ eliminate this action if we stick with offsite payment
  def attempt
    payment_params = params[:payment_authorizer]
    @payment_authorizer = PaymentAuthorizer.new(payment_params)
    amount = params[:donation_amount_in_cents].to_i

    if amount <= 98
      @error_message = "Your donation amount seems to be incorrect. Please try again."
      render :action => "new"
    elsif @payment_authorizer.attempt(amount)
      render :action => "receipt"
    else
      render :action => "new"
    end
  end
end
