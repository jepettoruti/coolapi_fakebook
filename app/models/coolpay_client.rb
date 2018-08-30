require 'httparty'

# This class provides a client to the Coolpay API using HTTParty
class CoolpayClient
  include HTTParty
  base_uri ENV['COOLPAY_API_URL']
  headers 'Content-Type' => 'application/json'

  # Authenrticates agains Coolpay and returns an auth token
  def authenticate(username = ENV['COOLPAY_USERNAME'], apikey = ENV['COOLPAY_API_KEY'])
    body = { username: username,
             apikey: apikey
           }.to_json

    response = self.class.post('/login', body: body)

    Rails.logger.info "Authenticating user #{username}, status #{response.code}."

    response.parsed_response['token']
  end


  # Adds a new recipient into Coolpay, returns the recipient ID
  def add_recipient(recipient_name)
    body = { recipient: { name:  recipient_name } }.to_json
    response = self.class.post('/recipients', body: body,
                                              headers: authorization_header
                                            )

    recipient_id = response.code == 201 ? response.parsed_response['recipient']['id'] : nil
    if response.code == 201
      Rails.logger.info "Created recipient #{recipient_name}: #{response.parsed_response['recipient']['id'] }"
      response.parsed_response['recipient']['id']
    else
      Rails.logger.info "Failed creating recipient #{recipient_name}"
      nil
    end
  end


  # Sends <currency><amount> to the recipient identified by ID, returns the newly
  # created payment ID
  def create_payment(amount, currency, recipient_id)
    body = { payment: {
                          amount:  amount,
                          currency: currency,
                          recipient_id: recipient_id
                      }
            }.to_json

    response = self.class.post('/payments', body: body,
                                            headers: authorization_header
                                          )
    # TODO: Improve responses over 422 statuses
    if response.code == 201
      Rails.logger.info "Created payment of #{currency} #{amount} to #{recipient_id}: #{response.parsed_response['payment']['id']}"
      response.parsed_response['payment']['id']
    elsif response.code == 422
      Rails.logger.info "Error creating payment of #{currency} #{amount} to #{recipient_id}: #{response.parsed_response['errors']}"
      nil
    else
      Rails.logger.info "Other error creating payment of #{currency} #{amount} to #{recipient_id}: #{response.code} #{response.body} }"
      nil
    end
  end

  # Gets all details about a payment
  def get_payment(payment_id)
    payments = get_payments
    payments.select { |payment| payment['id'] == payment_id }.first
  end

  # Checks if the payment status is 'paid'
  def payment_successful?(payment_id)
    payment = get_payment(payment_id)
    payment.nil? ? false : payment['status'] == 'paid'
  end

  private

    # Generates the authorization header used in other functions
    def authorization_header
      token = self.authenticate(ENV['COOLPAY_USERNAME'], ENV['COOLPAY_API_KEY'])
      { authorization: "Bearer #{token}" }
    end


    # Gets all payments from Coolpay, can potentially be a huge list
    def get_payments
      response = self.class.get('/payments', headers: authorization_header)
      response.parsed_response['payments']
    end
end
