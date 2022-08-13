require 'rails_helper'

RSpec.describe "Sessions", type: :request do

  describe "#new" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        login @user
        get login_path
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end

    # ゲストユーザーとして
    context "as a guest" do
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        get login_path
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end
  end

  describe "#create" do
    # 正しいユーザーとして
    context "as a correct user" do
      before do
        @user = FactoryBot.create(:user)
      end
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        login_params = FactoryBot.attributes_for(:user)
        post '/login', params: login_params
        expect(response).to have_http_status "200"
      end
    end

    # 誤ったユーザーとして
    context "as a incorrect user" do
    end
  end

  describe "#destroy" do
  end

end
