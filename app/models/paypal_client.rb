class PaypalClient
  attr_reader :transaction_id
  
  def initialize(credit_card, billing_address)
    @credit_card = credit_card
    @billing_address= billing_address
  end
  
  def attempt(price)
    if @credit_card.valid?
      return attempt_with_valid_credit_card(price)
    else
      return false
    end
  end
  
  private
  
  def attempt_with_valid_credit_card(price)
    response = gateway.authorize(price, @credit_card, {:ip => "", :billing_address => @billing_address})
    # ActiveRecord::Base.logger.warn("response: #{response.message}")
    # 
    if response.success?
      capture_result = gateway.capture(price, response.authorization)
      @transaction_id = capture_result.params['transaction_id']
      return true
    else
      return false
    end
  end
  
  def gateway
    return ActiveMerchant::Billing::PaypalGateway.new(CONFIG[:gateway_credentials])
  end
  
end