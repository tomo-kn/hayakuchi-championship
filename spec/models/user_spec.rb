require 'rails_helper'

RSpec.describe User, type: :model do

  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  # 名前、メール、パスワード、パスワード確認があれば有効な状態であること
  it "is valid with a name, email, and password" do
    user = User.new(
      name: "John",
      email: "john@example.com",
      password: "password",
      password_confirmation: "password"
    )
    expect(user).to be_valid
  end

  # 名前がなければ無効な状態であること
  it "is invalid without a name" do
    user = FactoryBot.build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  # メールがなければ無効な状態であること
  it "is invalid without a email" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  # パスワードとパスワード確認が一致していなければ無効な状態であること
  it "is invalid without matching a password and a password confirmation" do
    user = User.new(
      name: "Joe",
      email: "rspec@example.com",
      password: "password",
      password_confirmation: "password2"
    )
    user.valid?
    expect(user.errors[:password_confirmation]).to include("doesn't match Password")
  end

  # 重複した名前なら無効な状態であること
  it "is invalid with a duplicate name" do
    User.create(
      name: "Joe",
      email: "rspec@example.com",
      password: "password",
      password_confirmation: "password"
    )
    user = User.new(
      name: "Joe",
      email: "rspec2@example.com",
      password: "password",
      password_confirmation: "password"
    )
    user.valid?
    expect(user.errors[:name]).to include("has already been taken")
  end

  # 重複したメールなら無効な状態であること
  it "is invalid with a duplicate email address" do
    User.create(
      name: "Joe",
      email: "rspec@example.com",
      password: "password",
      password_confirmation: "password"
    )
    user = User.new(
      name: "Jane",
      email: "rspec@example.com",
      password: "password",
      password_confirmation: "password"
    )
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end

  # 名前が51文字以上なら無効な状態であること
  it "is invalid if the name has more than 51 characters" do
    user = User.new(
      name: "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxy",
      email: "john@example.com",
      password: "password",
      password_confirmation: "password"
    )
    user.valid?
    expect(user.errors[:name]).to include("is too long (maximum is 50 characters)")
  end

  # passwordが7文字以下なら無効な状態であること
  it "is invalid if the password has less than 7 characters" do
    user = User.new(
      name: "Joe",
      email: "john@example.com",
      password: "passwor",
      password_confirmation: "passwor"
    )
    user.valid?
    expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")
  end

  # emailアドレスが256文字以上なら無効な状態であること
  it "is invalid if the email address has more than 256 characters" do
    user = User.new(
      name: "Joe",
      email: "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghij@example.com",
      password: "password",
      password_confirmation: "password"
    )
    user.valid?
    expect(user.errors[:email]).to include("is too long (maximum is 255 characters)")
  end

  # emailアドレスの有効性検証その1
  it "is invalid if the email address is wrong:1(without a dot)" do
    user = User.new(
      name: "John",
      email: "john@examplecom",
      password: "password",
      password_confirmation: "password"
    )
    user.valid?
    expect(user.errors[:email]).to include("is invalid")
  end

  # emailアドレスの有効性検証その2
  it "is invalid if the email address is wrong:2(with a comma)" do
    user = User.new(
      name: "John",
      email: "john@example,com",
      password: "password",
      password_confirmation: "password"
    )
    user.valid?
    expect(user.errors[:email]).to include("is invalid")
  end

end


