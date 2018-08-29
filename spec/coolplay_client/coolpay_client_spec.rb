require "rails_helper"
require 'coolpay_client'

RSpec.describe CoolpayClient, :type => :model do
  before do
    @client = CoolpayClient.new
  end

  describe 'authentication' do

    context 'with valid credentials' do
      it 'should have receive authentication token' do
        token = @client.authenticate('JoseP','0AB19C178F932C03')
        expect(token).to be_truthy
      end
    end

    context 'with invalid credentials' do
      it 'should have receive authentication token' do
        token = @client.authenticate('not_a_valid_user','not_a_valid_key')
        expect(token).to be_nil
      end
    end

    context 'without passing credentials (using ENV)' do
      it 'should authenticate' do
        token = @client.authenticate
        expect(token).to be_truthy
      end
    end

  end

  describe 'recipient creation' do

    context 'successful' do
      it 'should add recipient' do
        recipient_id = @client.add_recipient('Johnny')
        expect(recipient_id).to be_truthy
      end
    end


    # The API usually gives 200s to any names, testing with empty name
    context 'with empty name' do
      it 'should fail' do
        recipient_id = @client.add_recipient('')
        expect(recipient_id).to be_nil
      end
    end

  end

end



# describe Credentials do
#   let(:default) { {'username': ENV['USERNAME'], 'apikey': ENV['API_KEY'] } }
#   let(:other)  { {"username": "your_username", "apikey": "5up3r$ecretKey!"} }
#   # subject(:credentials) { described_class.new }

#   describe('#format_json') do
#     it('formats the default credentials into json format') do
#       expect(credentials.format_json).to eq default
#     end

#     it('formats the given credentials into json format') do
#       cr = described_class.new(username: "your_username", apikey: "5up3r$ecretKey!")
#       expect(cr.format_json).to eq other
#     end
#   end
# end