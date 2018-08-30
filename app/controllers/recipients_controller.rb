require 'coolpay_client'

class RecipientsController < ApplicationController
  def add
    client = CoolpayClient.new
    if params[:name] != ""
      recipient_id = client.add_recipient(params[:name])
      if recipient_id.nil?
        render json: { status: 'ERROR' }, status: 422
      else
        render json: { status: 'SUCCESS', recipient_id: recipient_id }, status: :ok
      end
    else
      render json: { status: 'ERROR' }, status: 422
    end
  end
end
