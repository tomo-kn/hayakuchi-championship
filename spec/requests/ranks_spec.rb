require 'rails_helper'

RSpec.describe "Ranks", type: :request do

  describe "#index" do
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        login @user
        get rank_path
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end

    # ゲストユーザーとして
    context "as a guest" do
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        get rank_path
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end
  end
  
end
