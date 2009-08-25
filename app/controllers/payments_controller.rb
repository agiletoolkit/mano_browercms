class PaymentsController < ApplicationController
  def attempt
    payment_params = params[:payment_authorizer]
    @payment_authorizer = PaymentAuthorizer.new(payment_params)
    amount = params[:donation_amount_in_cents].to_i

    # TODO: create new model & save off transaction ID, name, email, payment amount

    if amount > 0 && @payment_authorizer.attempt(amount)
        render :template => "receipt"
    else
      render :template => "/donations/new"
    end
  end
end
