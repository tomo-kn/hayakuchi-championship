FactoryBot.define do
  factory :game do
    score { rand(30) }
    out { rand(0..3) }
    association :user
  end
end
