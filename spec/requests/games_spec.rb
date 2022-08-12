require 'rails_helper'

RSpec.describe "Games", type: :request do
  
  describe "#index" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        login @user
        get game_path
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end

    # ゲストユーザーとして
    context "as a guest" do
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        get game_path
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end
  end

  describe "#create" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end
    end

    # ゲストユーザーとして
    context "as a guest" do
    end
  end

  describe "#destroy" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end
    end

    # ゲストユーザーとして
    context "as a guest" do
    end
  end

end
