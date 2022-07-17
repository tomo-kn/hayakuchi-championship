# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Sentence.first_or_create!(
  [
    { content: 'バナナの謎はまだ謎なのだぞ',
      contentFurigana: 'バナナの謎はまだ謎なのだぞ',
      contentHiragana: 'ばななのなぞはまだなぞなのだぞ',
      contentMisconversion: 'バナナの謎はまだ謎なのだぞ'
    },
    { content: '赤カピバラ 青カピバラ 黄カピバラ',
      contentFurigana: '赤カピバラ 青カピバラ 黄カピバラ',
      contentHiragana: 'あかかぴばらあおかぴばらきかぴばら',
      contentMisconversion: '赤カピバラ 青カピバラ 黄カピバラ'
    },
    { content: '少女シャンソン歌手新春シャンソンショー',
      contentFurigana: '少女シャンソン歌手新春シャンソンショー',
      contentHiragana: 'しょうじょしゃんそんかしゅしんしゅんしゃんそんしょー',
      contentMisconversion: '少女シャンソン歌手新春シャンソンショー'
    },
    { content: 'この杭の釘は引き抜きにくい釘だ',
      contentFurigana: 'この杭の<ruby>釘<rp>（</rp><rt>クギ</rt><rp>）</rp></ruby>は引き抜きにくい<ruby>釘<rp>（</rp><rt>クギ</rt><rp>）</rp></ruby>だ',
      contentHiragana: 'このくいのくぎはひきぬきにくいくぎだ',
      contentMisconversion: 'この杭のクギは引き抜きにくいクギだ'
    },
    { content: 'マサチューセッツ州で魔術師修行中',
      contentFurigana: 'マサチューセッツ州で魔術師修行中',
      contentHiragana: 'まさちゅーせっつしゅうでまじゅつししゅぎょうちゅう',
      contentMisconversion: 'マサチューセッツ州で魔術師修行中'
    },
    { content: '本醸造醤油 高速増殖中',
      contentFurigana: '本醸造醤油 高速増殖中',
      contentHiragana: 'ほんじょうぞうしょうゆこうそくぞうしょくちゅう',
      contentMisconversion: '本醸造醤油 高速増殖中'
    },
    { content: '肩固かったから買った肩たたき機 肩たたきにくかった',
      contentFurigana: '肩固かったから買った肩たたき機 肩たたきにくかった',
      contentHiragana: 'かたかたかったからかったかたたたききかたたたきにくかった',
      contentMisconversion: '肩固かったから買った肩叩き機 肩叩きにくかった'
    },
    { content: '竹垣に竹立てかけたかったから竹立てかけた',
      contentFurigana: '<ruby>竹垣<rp>（</rp><rt>たけがき</rt><rp>）</rp></ruby>に竹立てかけたかったから竹立てかけた',
      contentHiragana: 'たけがきにたけたてかけたかったからたけたてかけた',
      contentMisconversion: '竹垣に竹立てかけたかったから竹立てかけた'
    },
    { content: '左折車専用車線 右折車が逆走',
      contentFurigana: '左折車専用車線 右折車が逆走',
      contentHiragana: 'させつしゃせんようしゃせんうせつしゃがぎゃくそう',
      contentMisconversion: '左折者専用車線 右折者が逆走'
    },
    { content: '商社の社長が 調査書捜査中',
      contentFurigana: '商社の社長が 調査書捜査中',
      contentHiragana: 'しょうしゃのしゃちょうがちょうさしょそうさちゅう',
      contentMisconversion: '商社の社長が 調査書操作中'
    },
    { content: '東京特許許可局 許可局長の許可',
      contentFurigana: '東京特許許可局 許可局長の許可',
      contentHiragana: 'とうきょうとっきょきょかきょくきょかきょくちょうのきょか',
      contentMisconversion: '東京特許許可局 許可局長の許可'
    },
    { content: 'ブスバスガイド バスガス爆発',
      contentFurigana: 'ブスバスガイド バスガス爆発',
      contentHiragana: 'ぶすばすがいどばすがすばくはつ',
      contentMisconversion: 'ブスバスガイド バスガス爆発'
    },
    { content: 'よぼよぼ病予防病院予防病室',
      contentFurigana: 'よぼよぼ病予防病院予防病室',
      contentHiragana: 'よぼよぼびょうよぼうびょういんよぼうびょうしつ',
      contentMisconversion: 'よぼよぼ秒予防病院予防病室'
    },
    { content: 'レモンとメロンをレミオロメン ルミオンで食す',
      contentFurigana: 'レモンとメロンをレミオロメン ルミオンで<ruby>食<rp>（</rp><rt>しょく</rt><rp>）</rp></ruby>す',
      contentHiragana: 'れもんとめろんをれみおろめんるみおんでしょくす',
      contentMisconversion: 'レモンとメロンをレミオロメン ルミオンで食す'
    },
    { content: '笑わば笑え わらわは笑われる謂れはない',
      contentFurigana: '笑わば笑え わらわは笑われる<ruby>謂<rp>（</rp><rt>いわ</rt><rp>）</rp></ruby>れはない',
      contentHiragana: 'わらわばわらえわらわはわらわれるいわれはない',
      contentMisconversion: '笑わば笑え 笑わは笑われる謂れはない'
    },
    { content: '京の生鱈 奈良生まな鰹',
      contentFurigana: '京の<ruby>生鱈<rp>（</rp><rt>なまだら</rt><rp>）</rp></ruby> 奈良生まな<ruby>鰹<rp>（</rp><rt>がつお</rt><rp>）</rp></ruby>',
      contentHiragana: 'きょうのなまだらならなままながつお',
      contentMisconversion: 'きょうのなまだらならなままながつお'
    }
  ]
)

User.first_or_create!(
  name: "test",
  email: "test@example.com",
  password: "password",
  password_confirmation: "password"
)