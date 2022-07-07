# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Sentence.first_or_create!(
  [
    { content: 'バナナの謎はまだ謎なのだぞ' },
    { content: 'あの長押の長薙刀は誰が長薙刀ぞ' },
    { content: '赤カピバラ 青カピバラ 黄カピバラ' },
    { content: '少女シャンソン歌手新春シャンソンショー' },
    { content: 'この杭のクギは引き抜きにくいクギだ' },
    { content: 'マサチューセッツ州で魔術師修行中' },
    { content: '本醸造醤油 高速増殖中' },
    { content: '肩固かったから買った肩叩き機 肩叩きにくかった' },
    { content: '竹垣に竹立てかけたかったから竹立てかけた' },
    { content: '左折車専用車線 右折車が逆走' },
    { content: '商社の社長が 調査書捜査中' },
    { content: '蝶々(ちょうちょう)ちょっとちょっとだけ取ってちょうだい' },
    { content: '東京特許許可局許可局長の許可' },
    { content: 'ブスバスガイド バスガス爆発' },
    { content: 'よぼよぼ病予防病院予防病室' },
    { content: 'レモンとメロンをレミオロメン ルミオンで食す' },
    { content: '笑わば笑えわらわは笑われる謂れはない' },
    { content: '京の生鱈 奈良生まな鰹' }
  ]
)

User.first_or_create!(
  name: "test",
  email: "test@example.com",
  password: "password",
  password_confirmation: "password"
)