require 'rails_helper'

RSpec.describe User, type: :model do

  it "name と email を持ったユーザーを登録できること" do
    user = User.new(
      name: "John",
      email: "john@example.com",
    )
    expect(user).to be_valid
  end
end


