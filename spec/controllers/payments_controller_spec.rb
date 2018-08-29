require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do

  describe "POST #create" do
    it "returns http success with valid parameters" do
      post :create, params: {amount: 20, currency: "GBP", recipient_id: '92b301cb-5d02-4a9f-b149-62b6320ae43d'}
      expect(response).to have_http_status(:success)
    end

    it "returns http 422 with invalid amount" do
      post :create, params: {amount: -1, currency: "GBP", recipient_id: '92b301cb-5d02-4a9f-b149-62b6320ae43d'}
      expect(response).to have_http_status(422)
    end

    it "returns http 422 with not accepted currency" do
      post :create, params: {amount: 30, currency: "USD", recipient_id: '92b301cb-5d02-4a9f-b149-62b6320ae43d'}
      expect(response).to have_http_status(422)
    end

    it "returns http 404 with invalid recipient_id" do
      post :create, params: {amount: 30, currency: "EUR", recipient_id: '92b301cb------4a9f-b149-62b6320ae4d2'}
      expect(response).to have_http_status(404)
    end

    it "returns http 422 with no recipient_id" do
      post :create, params: {amount: 30, currency: "USD"}
      expect(response).to have_http_status(422)
    end

    it "returns http 422 with no currency" do
      post :create, params: {amount: 30, recipient_id: '92b301cb-5d02-4a9f-b149-62b6320ae4d'}
      expect(response).to have_http_status(422)
    end

    it "returns http 422 with no amount" do
      post :create, params: {currency: "USD", recipient_id: '92b301cb-5d02-4a9f-b149-62b6320ae4d'}
      expect(response).to have_http_status(422)
    end
  end

  describe "GET #status" do
    it "returns http success with a valid payment" do
      get :status, params: {payment_id: '48d65fc9-770c-4048-b8ae-3e3932934697'}, format: :json
      expect(response).to have_http_status(:success)
    end

    it "returns http 404 with a invalid payment" do
      get :status, params: {payment_id: '48d65fc9-----4048-b8ae-3e3932934697'}, format: :json
      expect(response).to have_http_status(404)
    end

    it "returns http 422 with no payment" do
      get :status, format: :json
      expect(response).to have_http_status(422)
    end

  end

end
