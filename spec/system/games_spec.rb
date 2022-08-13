require 'rails_helper'

RSpec.describe "Games", type: :system do

  before do
    @user = FactoryBot.create(:user)
  end
  
  # ユーザーはログインしているときに、マイスコアの記述を確認する
  scenario "user checks a myscore when user logged in" do
    login @user
    visit game_path
    find('body').has_text?('マイスコア')
  end

  # ユーザーは非ログイン時に、ログインや新規会員登録を促す記述を確認する
  scenario "user checks a login and register recommendation when user did not log in" do
    visit game_path
    expect(find('#loginAndMembership').text).to eq "ログインはこちら 新規会員登録はこちら"
  end
end
