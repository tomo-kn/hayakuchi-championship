require 'rails_helper'

RSpec.describe "Pages", type: :request do

  describe "#index" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        login @user
        get root_path
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end

    # ゲストユーザーとして
    context "as a guest" do
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        get root_path
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end
  end

  describe "#policy" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        login @user
        get '/policy'
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end

    # ゲストユーザーとして
    context "as a guest" do
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        get '/policy'
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end
  end

  describe "#contact" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        login @user
        get '/contact'
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end

    # ゲストユーザーとして
    context "as a guest" do
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        get '/contact'
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end
    
  end

  describe "#terms" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        login @user
        get '/terms'
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end

    # ゲストユーザーとして
    context "as a guest" do
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        get '/terms'
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end
  end

end
