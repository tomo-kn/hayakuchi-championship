FactoryBot.define do
  factory :sentence do
    content { |n| "test#{n}" }
    contentFurigana { |m| "testFurigana#{m}" }
    contentMisconversion { "なし" }
  end
end
