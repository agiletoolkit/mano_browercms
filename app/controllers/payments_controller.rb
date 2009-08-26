class PaymentsController < ApplicationController
  skip_before_filter :redirect_to_iphone
  acts_as_iphone_controller
  
  def new
    @payment_authorizer = PaymentAuthorizer.new
  end
  
  def attempt
    payment_params = params[:payment_authorizer].merge(params[:date])
    @payment_authorizer = PaymentAuthorizer.new(payment_params)
    amount = params[:donation_amount_in_cents].to_i

    # TODO: create new model & save off transaction ID, name, email, payment amount

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
