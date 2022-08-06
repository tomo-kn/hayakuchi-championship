# ランキング機能実装のため、1ユーザーごとに15つ程度ランダムにゲームスコアを用意しておく

User.all.each do |user|
  15.times do
    user.games.create!(
      score: rand(30),
      out: rand(0..3)
  )
  end
end