require 'rails_helper'

RSpec.describe "Practices", type: :system do

  before do
    @user = FactoryBot.create(:user)
  end
  # 認証されたユーザーとして
  context "as an authenticated user" do
    # マイスコアの記述を確認する
    scenario "user checks a myscore" do
      login @user
      Sentence.all.each do |sentence|
        visit practice_path(sentence)
        find('body').has_text?('マイスコア')
      end
    end
  end

  # ゲストとして
  context "as a guest" do
    # ログインや新規会員登録を促す記述を確認する
    scenario "user checks a login and register recommendation" do
      Sentence.all.each do |sentence|
        visit practice_path(sentence)
        expect(find('#loginAndMembership').text).to eq "ログインはこちら 新規会員登録はこちら"
      end
    end
  end
end
