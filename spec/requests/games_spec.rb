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
        allow_any_instance_of(SessionsHelper).to receive(:current_user).and_return(@user)
      end
      # ゲームスコアを追加できること
      it "adds a game result" do
        game_params = FactoryBot.attributes_for(:game)
        login @user
        expect {
          post '/game', params: { game: game_params }
        }.to change(@user.games, :count).by(1)
      end
    end

    # ゲストユーザーとして
    context "as a guest" do
      # 302レスポンスを返すこと
      it "returns a 302 response" do
        game_params = FactoryBot.attributes_for(:game)
        post '/game', params: { game: game_params }
        expect(response).to have_http_status "302"
      end
      #ログイン画面にリダイレクトすること
      it "redirects to the login page" do
        game_params = FactoryBot.attributes_for(:game)
        post '/game', params: { game: game_params }
        expect(response).to redirect_to '/login'
      end
    end
  end

  describe "#destroy" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
        @game = FactoryBot.create(:game, user_id: @user.id)
        allow_any_instance_of(SessionsHelper).to receive(:current_user).and_return(@user)
      end
      # ゲームスコアを削除できること
      it "deletes a game score" do
        login @user
        expect {
          delete "/games/#{@game.id}", params: { id: @game.id }
        }.to change(@user.games, :count).by(-1)
      end
      # マイページにリダイレクトすること
      it "redirects to my page" do
        login @user
        delete "/games/#{@game.id}", params: { id: @game.id }
        expect(response).to redirect_to user_path(@user.id)
      end
    end

    # 認証されていないユーザーとして
    context "as an unauthorized user" do
      before do
        @user = FactoryBot.create(:user)
        @other_user = FactoryBot.create(:user)
        @game = FactoryBot.create(:game, user_id: @user.id)
        allow_any_instance_of(SessionsHelper).to receive(:current_user).and_return(@other_user)
      end
      # ゲームスコアを削除できないこと
      it "does not delete a game score" do
        login @other_user
        expect {
          delete "/games/#{@game.id}", params: { id: @game.id }
        }.to_not change(Game, :count)
      end
      # ログイン画面にリダイレクトすること
      it "redirects to the login page" do
        login @other_user
        delete "/games/#{@game.id}", params: { id: @game.id }
        expect(response).to redirect_to '/login'
      end
    end

    # ゲストユーザーとして
    context "as a guest" do
      before do
        @game = FactoryBot.create(:game)
      end
      # 302レスポンスを返すこと
      it "returns a 302 response" do
        delete "/games/#{@game.id}", params: { id: @game.id }
        expect(response).to have_http_status "302"
      end
      # ログイン画面にリダイレクトすること
      it "redirects to the login page" do
        delete "/games/#{@game.id}", params: { id: @game.id }
        expect(response).to redirect_to '/login'
      end
      # ゲームスコアを削除できないこと
      it "does not delete a game score" do
        expect {
          delete "/games/#{@game.id}", params: { id: @game.id }
        }.to_not change(Game, :count)
      end
    end
  end

end
