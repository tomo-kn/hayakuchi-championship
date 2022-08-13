require 'rails_helper'

RSpec.describe "Pages", type: :system do

  before do
    @user = FactoryBot.create(:user)
  end

  # ユーザーはログインしているときに、ログイン中の記述を確認する
  scenario "user checks a login messsage when user logged in" do
    login @user
    visit root_path
    find('body').has_text?('ログインしています')
  end

  # ユーザーは非ログイン時に、非ログインの記述を確認する
  scenario "user checks a login recommendation when user did not log in" do
    visit root_path
    find('body').has_text?('ログインしていません')
  end
end
