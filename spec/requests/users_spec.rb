require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe "#new" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        login @user
        get new_user_path
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end

    # ゲストユーザーとして
    context "as a guest" do
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        get new_user_path
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
      # 新規会員登録ができること
      it "registers as a new user" do
        login @user
        @other_user = FactoryBot.build(:user)
        expect {
          sign_up @other_user
        }.to change(User, :count).by(1)
      end
    end

    # ゲストユーザーとして
    context "as a guest" do
      # 新規会員登録ができること
      it "registers as a new user" do
        @other_user = FactoryBot.build(:user)
        expect {
          sign_up @other_user
        }.to change(User, :count).by(1)
      end
    end
  end

  describe "#show" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
        allow_any_instance_of(SessionsHelper).to receive(:current_user).and_return(@user)
      end
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        login @user
        get user_path(@user.id)
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end

    # ゲストユーザーとして
    context "as a guest" do
      before do
        @user = FactoryBot.create(:user)
      end
      # 302レスポンスを返すこと
      it "returns a 302 response" do
        get user_path(@user.id)
        expect(response).to have_http_status "302"
      end
      # ログイン画面にリダイレクトすること
      it "redirects to the login page" do
        get user_path(@user.id)
        expect(response).to redirect_to '/login'
      end
    end
  end

  describe "#edit" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
        allow_any_instance_of(SessionsHelper).to receive(:current_user).and_return(@user)
      end
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        login @user
        get edit_user_path(@user.id)
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end

    # ゲストユーザーとして
    context "as a guest" do
      before do
        @user = FactoryBot.create(:user)
      end
      # 302レスポンスを返すこと
      it "returns a 302 response" do
        get edit_user_path(@user.id)
        expect(response).to have_http_status "302"
      end
      # ログイン画面にリダイレクトすること
      it "redirects to the login page" do
        get edit_user_path(@user.id)
        expect(response).to redirect_to '/login'
      end
    end
  end

  describe "#update" do
    # ゲストユーザーとして
    context "as a guest" do
      before do
        @user = FactoryBot.create(:user)
      end
      # 302レスポンスを返すこと
      it "returns a 302 response" do
        user_params = {
          name: "Change",
          email: "change@example.com",
          password: "changepass",
          password_confirmation: "changepass"
        }
        patch user_path(@user.id), params: { user: user_params }
        expect(response).to have_http_status "302"
      end
      # ログイン画面にリダイレクトすること
      it "redirects to the login page" do
        user_params = {
          name: "Change",
          email: "change@example.com",
          password: "changepass",
          password_confirmation: "changepass"
        }
        patch user_path(@user.id), params: { user: user_params }
        expect(response).to redirect_to '/login'
      end
    end
  end

end
