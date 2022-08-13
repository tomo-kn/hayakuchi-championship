module SignUpModule
  def sign_up(user)
    visit('/users/new')
    fill_in 'アカウント名', with: user.name
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード確認', with: 'password'
    click_on '登録する'
  end
end