FactoryBot.define do
  factory :practice do
    score { Random.rand(99.5).ceil(1) }
    time { Random.rand(9.5).ceil(1) }
    voice { "voice.wav" }
    word { "test" }
    association :user
    association :sentence
  end
end
