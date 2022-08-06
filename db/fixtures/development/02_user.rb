# sorcery の認証機能を実装するため、Userに関してはデフォルトのseedを使う
# 25ユーザーをn=3～27で作る

25.times do |n|
  User.first_or_create!(
    name: "test#{n + 3}",
    email: "test#{n + 3}@example.com",
    password: "password",
    password_confirmation: "password"
  )
end