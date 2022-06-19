require 'rails_helper'

RSpec.describe "Practices", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/practices/index"
      expect(response).to have_http_status(:success)
    end
  end

end
