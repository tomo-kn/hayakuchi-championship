# sorcery の認証機能を実装するため、Userに関してはデフォルトのseedを使う
User.first_or_create!(
  name: "test",
  email: "test@example.com",
  password: "password",
  password_confirmation: "password"
)