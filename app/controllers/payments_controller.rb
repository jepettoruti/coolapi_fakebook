require 'coolpay_client'

class PaymentsController < ApplicationController
  def create
    client = CoolpayClient.new

    accepted_currencies = ['GBP', 'EUR', 'ARS', 'AED']

    if (params[:amount].to_f > 0 && accepted_currencies.include?(params[:currency]) && params[:recipient_id])
      payment_id = client.create_payment(params[:amount], params[:currency], params[:recipient_id])

      if payment_id.nil?
        render json: { status: 'ERROR' }, status: 404
      else
        render json: { status: 'SUCCESS', payment_id: payment_id }, status: :ok
      end

    else
      render json: { status: 'ERROR' }, status: 422
    end
  end

  def status
    client = CoolpayClient.new
    if params[:payment_id]
      payment = client.get_payment(params[:payment_id])
      Rails.logger.info payment
      if payment.nil?
        render json: { status: 'ERROR' }, status: 404
      else
        render json: { payment_status: payment['status'] }, status: :ok
      end
    else
      render json: { status: 'ERROR' }, status: 422
    end
  end
end
