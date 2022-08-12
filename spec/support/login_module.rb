module LoginModule
  def login(user)
    visit('/login')
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    find('input[type="submit"]').click
  end
end