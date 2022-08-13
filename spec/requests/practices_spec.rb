require 'rails_helper'

RSpec.describe "Practices", type: :request do

  describe "#index" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        login @user
        get practices_path
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end

    # ゲストユーザーとして
    context "as a guest" do
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        get practices_path
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end
  end

  describe "#show" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        login @user
        @sentences = Sentence.all
        @sentences.each do |sentence|
        get practice_path(sentence)
        expect(response).to be_successful
        expect(response).to have_http_status "200"
        end
      end
    end

    # ゲストユーザーとして
    context "as a guest" do
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        @sentences = Sentence.all
        @sentences.each do |sentence|
        get practice_path(sentence)
        expect(response).to be_successful
        expect(response).to have_http_status "200"
        end
      end
    end
  end

  describe "#create" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
        allow_any_instance_of(SessionsHelper).to receive(:current_user).and_return(@user)
      end
      # 練習結果を保存できること
      it "adds a practice result" do
        practice_params = FactoryBot.attributes_for(:practice, sentence_id: rand(1..15))
        login @user
        expect {
          post "/practices/#{practice_params[:sentence_id]}", params: { practice: practice_params }
        }.to change(@user.practices, :count).by(1)
      end
    end

    # ゲストユーザーとして
    context "as a guest" do
      # 302レスポンスを返すこと
      it "returns a 302 response" do
        practice_params = FactoryBot.attributes_for(:practice, sentence_id: rand(1..15))
        post "/practices/#{practice_params[:sentence_id]}", params: { practice: practice_params }
        expect(response).to have_http_status "302"
      end
      # ログイン画面にリダイレクトすること
      it "redirects to the login page" do
        practice_params = FactoryBot.attributes_for(:practice, sentence_id: rand(1..15))
        post "/practices/#{practice_params[:sentence_id]}", params: { practice: practice_params }
        expect(response).to redirect_to '/login'
      end
    end
  end

  describe "#result" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
        @sentence = FactoryBot.create(:sentence)
        @practice = FactoryBot.create(:practice, user_id: @user.id, sentence_id: @sentence.id)
        allow_any_instance_of(SessionsHelper).to receive(:current_user).and_return(@user)
      end
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        login @user
        get "/results/#{@practice.id}"
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end

    # 認証されていないユーザーとして
    context "as an unauthorized user" do
      before do
        @user = FactoryBot.create(:user)
        @other_user = FactoryBot.create(:user)
        @sentence = FactoryBot.create(:sentence)
        @practice = FactoryBot.create(:practice, user_id: @user.id, sentence_id: @sentence.id)
        allow_any_instance_of(SessionsHelper).to receive(:current_user).and_return(@other_user)
      end
      # 302レスポンスを返すこと
      it "returns a 302 response" do
        login @other_user
        get "/results/#{@practice.id}"
        expect(response).to have_http_status "302"
      end
      # ログイン画面にリダイレクトすること
      it "redirects to the login page" do
        login @other_user
        get "/results/#{@practice.id}"
        expect(response).to redirect_to '/login'
      end
    end

    # ゲストユーザーとして
    context "as a guest" do
      before do
        @user = FactoryBot.create(:user)
        @sentence = FactoryBot.create(:sentence)
        @practice = FactoryBot.create(:practice, user_id: @user.id, sentence_id: @sentence.id)
      end
      # 302レスポンスを返すこと
      it "returns a 302 response" do
        get "/results/#{@practice.id}"
        expect(response).to have_http_status "302"
      end
      # ログイン画面にリダイレクトすること
      it "redirects to the login page" do
        get "/results/#{@practice.id}"
        expect(response).to redirect_to '/login'
      end
    end
  end

  describe "#destroy" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
        @sentence = FactoryBot.create(:sentence)
        @practice = FactoryBot.create(:practice, user_id: @user.id, sentence_id: @sentence.id)
        allow_any_instance_of(SessionsHelper).to receive(:current_user).and_return(@user)
      end
      # 練習結果を削除できること
      it "deletes a practice result" do
        login @user
        expect {
          delete "/results/#{@practice.id}", params: { id: @practice.id }
        }.to change(@user.practices, :count).by(-1)
      end
      # マイページにリダイレクトすること
      it "redirects to my page" do
        login @user
        delete "/results/#{@practice.id}", params: { id: @practice.id }
        expect(response).to redirect_to user_path(@user.id)
      end
    end

    # 認証されていないユーザーとして
    context "as an unauthorized user" do
      before do
        @user = FactoryBot.create(:user)
        @other_user = FactoryBot.create(:user)
        @sentence = FactoryBot.create(:sentence)
        @practice = FactoryBot.create(:practice, user_id: @user.id, sentence_id: @sentence.id)
        allow_any_instance_of(SessionsHelper).to receive(:current_user).and_return(@other_user)
      end
      # 練習結果を削除できないこと
      it "does not delete a practice result" do
        login @other_user
        expect {
          delete "/results/#{@practice.id}", params: { id: @practice.id }
        }.to_not change(Practice, :count)
      end
      # ログイン画面にリダイレクトすること
      it "redirects to the login page" do
        login @other_user
        delete "/results/#{@practice.id}", params: { id: @practice.id }
        expect(response).to redirect_to '/login'
      end
    end

    # ゲストユーザーとして
    context "as a guest" do
      before do
        @user = FactoryBot.create(:user)
        @sentence = FactoryBot.create(:sentence)
        @practice = FactoryBot.create(:practice, user_id: @user.id, sentence_id: @sentence.id)
      end
      # 302レスポンスを返すこと
      it "returns a 302 response" do
        delete "/results/#{@practice.id}", params: { id: @practice.id }
        expect(response).to have_http_status "302"
      end
      # ログイン画面にリダイレクトすること
      it "redirects to the login page" do
        delete "/results/#{@practice.id}", params: { id: @practice.id }
        expect(response).to redirect_to '/login'
      end
      # 練習結果を削除できないこと
      it "does not delete a practice result" do
        expect {
          delete "/results/#{@practice.id}", params: { id: @practice.id }
        }.to_not change(Practice, :count)
      end
    end
  end

end
