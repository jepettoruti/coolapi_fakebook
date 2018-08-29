require 'httparty'

# This class provides a client to the Coolpay API using HTTParty
class CoolpayClient
  include HTTParty
  base_uri ENV['COOLPAY_API_URL']
  headers 'Content-Type' => 'application/json'

  # Authenrticates agains Coolpay and returns an auth token
  def authenticate
    body = { username: ENV['COOLPAY_USERNAME'],
             apikey: ENV['COOLPAY_API_KEY'] 
           }.to_json

    response = self.class.post("/login", { body: body } )
    response.parsed_response['token']
  end

  # Adds a new recipient into Coolpay, returns the recipient ID
  def add_recipient(recipient_name)
    body = { recipient: { name:  recipient_name } }.to_json
    response = self.class.post("/recipients", { 
                                                body: body, 
                                                headers: authorization_header
                                              } )
    response.parsed_response['recipient']['id']
  end

  # Sends <currency><amount> money to the recipient identified by ID, returns the newly 
  # created payment ID
  def send_money(amount, currency, recipient_id)
    body = { payment: { 
                          amount:  amount,
                          currency: currency,
                          recipient_id: recipient_id
                      } 
            }.to_json

    response = self.class.post("/payments", { 
                                                body: body, 
                                                headers: authorization_header
                                              } )
    response.parsed_response['payment']
  end

  # Gets all details about a payment
  def get_payment(payment_id)
    payments = get_payments
    payment_index = payments.index { |x| x['id'] == payment_id }
    payments[payment_index]
  end

  # Checks if the payment status is 'paid'
  def payment_successful?(payment_id)
    payment = get_payment(payment_id)
    payment['status']=='paid'
  end

  private

  # Generates the authorization header used in other functions
  def authorization_header
    token = self.authenticate
    { :authorization => "Bearer #{token}" }
  end

  # Gets all payments from Coolpay, can potentially be a huge list
  def get_payments
    response = self.class.get("/payments", { headers: authorization_header } )
    response.parsed_response['payments']
  end
  
end