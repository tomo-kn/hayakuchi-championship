# 早口言葉選手権
![rails](https://img.shields.io/badge/Rails-v6.1.6-red)

### https://hayakuchi-championship.com/

### サービス概要
早口言葉に音声入力とタイピングゲームの要素を組み合わせた、滑舌改善のためのWebサービスです。<br>
若い方からお年寄りまで、スコアを競いながら楽しく滑舌を改善することができます。

### メインのターゲットユーザー
- 滑舌や話し方に悩みがある人
- 早口言葉が得意であり、力試しがしたい人
- 滑舌が仕事のパフォーマンスに大きく影響する人(例.アナウンサー、お笑い芸人、音声認識を積極的に活用しているWebライターなど)

## 主な画面・機能一覧
| トップページ|
| --------------------------------------------------------------------|
| <img src="https://gyazo.com/ab16a1be40415999a7dc2eef37622b39.png">|
| ・試合するか練習するかを選択できる|

| 試合ページ|
| --------------------------------------------------------------------|
| <img src="https://gyazo.com/f41f425dee4ab3ed42d2c8a5377221c3.png">|
| ・表示されるお題を発声すると、発音の精度により点数がもらえる<br>・アウトが3回重なるか、60秒の制限時間を使い切ったらゲームオーバー|

| 練習ページ| 結果ページ|
| ------------------------------------------------------------------|--------------------------------------------------------------------|
| <img src="https://gyazo.com/1981c6d3977ceb7292c65c6bc5fba6ab.png">|<img src="https://gyazo.com/4644f581418e20c52c85630ae127633b.png">|
| ・試合モードで出題されるお題を個別に練習できるモード| ・録音した音声を再生できる|

| マイページ|
| --------------------------------------------------------------------|
| <img src="https://gyazo.com/71841a3bd701672f63362b971895b7e1.png">|
| ・試合結果や練習結果をいつでも見返したり復習したりできるページ|

| ランキング|
| --------------------------------------------------------------------|
| <img src="https://gyazo.com/7871cb805f5b62438d9ddbd945e32a35.png">|
| ・ライバルたちとスコアで競おう！|

## 使用技術
- Ruby(3.1.2)
- Ruby on Rails(6.1.6)
- JavaScript
- JQuery
- AWS(ECS, ECR, Fargate, RDS, Route53, ALB, ACM, S3)
- Docker
- CircleCI
- RSpec
- MySQL

### 使用API
- WebSpeechAPI(音声認識に使用)

### 主要gem
- carrierwave-audio
- fog-aws
- bootstrap
- jquery-rails

### インフラ構成(アーキテクチャ)図
<img src="https://gyazo.com/360f1565f511847763af18ea808e0d67.png">

### ER図
<img src="https://gyazo.com/f4333f0409d7e7b1a7df0a9f3a54d742.png">

## 関連ページ
- Twitterハッシュタグ: [#早口言葉選手権](https://twitter.com/hashtag/%E6%97%A9%E5%8F%A3%E8%A8%80%E8%91%89%E9%81%B8%E6%89%8B%E6%A8%A9?src=hashtag_click)
- Qiita記事: [【個人開発】楽しみながら滑舌を鍛えることができるWebアプリ『早口言葉選手権』をリリースしました⚾🏏](https://qiita.com/tomo-kn/items/293280565b7ab69506e5)
