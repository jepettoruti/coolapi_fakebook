require "rails_helper"
require 'coolpay_client'

RSpec.describe CoolpayClient, type: :model do
  let(:client) { CoolpayClient.new }

  describe 'authentication' do

    context 'with valid credentials' do
      it 'should have receive authentication token' do
        token = client.authenticate('JoseP', '0AB19C178F932C03')
        expect(token).to be_truthy
      end
    end

    context 'with invalid credentials' do
      it 'should have receive authentication token' do
        token = client.authenticate('not_a_valid_user', 'not_a_valid_key')
        expect(token).to be_nil
      end
    end

    context 'without passing credentials (using ENV)' do
      it 'should authenticate' do
        token = client.authenticate
        expect(token).to be_truthy
      end
    end

  end

  describe 'recipient creation' do

    context 'successful' do
      it 'should add recipient' do
        recipient_id = client.add_recipient('Johnny')
        expect(recipient_id).to be_truthy
      end
    end

    # The API usually gives 201s to any names, testing with empty name
    context 'with empty name' do
      it 'should fail' do
        recipient_id = client.add_recipient('')
        expect(recipient_id).to be_nil
      end
    end
  end

  describe 'payment creation' do
    context 'recipient exists' do
      it 'should create a payment' do
        recipient_id = client.add_recipient('Johnny')
        payment_id = client.create_payment(20, 'GBP', recipient_id)
        expect(payment_id).to be_truthy
      end
    end

    context 'recipient does not exist' do
      it 'should fail payment creation' do
        payment_id = client.create_payment(10000, 'ARS', 'aed01bf1-a3d8-402e-937d-c2a96f56f65a')
        expect(payment_id).to be_nil
      end
    end

    context 'recipient_id is invalid' do
      it 'should fail payment creation' do
        payment_id = client.create_payment(99, 'AED', 'broken_recipient')
        expect(payment_id).to be_nil
      end
    end

    context 'recipient exists' do
      it 'should create a payment' do
        recipient_id = client.add_recipient('Johnny')
        payment_id = client.create_payment(30, 'EUR', recipient_id)
        payment = client.get_payment(payment_id)
        aggregate_failures "and payment is actually there" do
          expect(payment).to be_truthy
          expect(payment['recipient_id']).to eq recipient_id
          expect(payment['id']).to eq payment_id
          expect(payment['currency']).to eq 'EUR'
          expect(payment['amount']).to eq "30"
        end
      end
    end

    # Not testing the check_payment method as not all payments actually work

  end

end
