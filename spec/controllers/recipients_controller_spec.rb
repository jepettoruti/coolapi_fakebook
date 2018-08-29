require 'rails_helper'

RSpec.describe RecipientsController, type: :controller do

  describe "POST #add" do
    it "returns http success with valid " do
      post :add, params: {name: 'Paul'}
      expect(response).to have_http_status(:success)
    end

    it "returns http 422 with empty name " do
      post :add, params: {name: ''}
      expect(response).to have_http_status(422)
    end

    it "returns http 422 with no name " do
      post :add
      expect(response).to have_http_status(422)
    end
  end

end
