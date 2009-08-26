require 'active_merchant'
require "active_merchant/billing/gateways/paypal.rb"

class PaymentAuthorizer < ActiveValidations::Base
  attr_accessor :first_name, :last_name, :credit_card_number, :expiration_month, :expiration_year, :card_security_code, :address_line_one, :city, :state, :zip, :country, :email_address
  attr_reader :transaction_id

  validates_presence_of :first_name, :last_name, :expiration_month, :expiration_year, :address_line_one, :city, :state, :country
  validates_numericality_of :credit_card_number, :card_security_code, :zip, :message => "must be a number"
  validates_format_of :email_address, :with => /^[^@]+@[^@]+\.[^@]+$/
    
  def credit_card_number
    return @credit_card_number.gsub("-", "") if @credit_card_number
  end
  
  def full_name
    return "#{@first_name} #{@last_name}"
  end
  
  def attempt(amount)
    return false unless valid?
    paypal_client = PaypalClient.new(credit_card, billing_address)
    if paypal_client.attempt(amount)
      @transaction_id = paypal_client.transaction_id
      return true
    else
      @errors.add_to_base("Payment not accepted.  Please edit your information and try again")
      return false
    end
  end
  
  private #############################################################
  
  def billing_address
    return {:name => "#{first_name} #{last_name}", :address1 => @address_line_one, :city => @city, :state => @state, :zip => @zip, :country => @country}
  end
  
  def credit_card
    return ActiveMerchant::Billing::CreditCard.new(
      :first_name => @first_name, :last_name => @last_name, 
      :number => @credit_card_number, :verification_value => @card_security_code,
      :month => @expiration_month, :year => @expiration_year)
  end
end