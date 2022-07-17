Sentence.seed do |s|
  s.id = 1
  s.content = "バナナの謎はまだ謎なのだぞ"
  s.contentFurigana = "バナナの謎はまだ謎なのだぞ"
  s.contentMisconversion = "なし"
end

Sentence.seed do |s|
  s.id = 2
  s.content = "赤カピバラ 青カピバラ 黄カピバラ"
  s.contentFurigana = "赤カピバラ 青カピバラ 黄カピバラ"
  s.contentMisconversion = "なし"
end

Sentence.seed do |s|
  s.id = 3
  s.content = "少女シャンソン歌手新春シャンソンショー"
  s.contentFurigana = "少女シャンソン歌手新春シャンソンショー"
  s.contentMisconversion = "なし"
end

Sentence.seed do |s|
  s.id = 4
  s.content = "この杭の釘は引き抜きにくい釘だ"
  s.contentFurigana = "この杭の<ruby>釘<rp>（</rp><rt>クギ</rt><rp>）</rp></ruby>は引き抜きにくい<ruby>釘<rp>（</rp><rt>クギ</rt><rp>）</rp></ruby>だ"
  s.contentMisconversion = "あり,この杭のクギは引き抜きにくいクギだ"
end

Sentence.seed do |s|
  s.id = 5
  s.content = "マサチューセッツ州で魔術師修行中"
  s.contentFurigana = "マサチューセッツ州で魔術師修行中"
  s.contentMisconversion = "なし"
end

Sentence.seed do |s|
  s.id = 6
  s.content = "本醸造醤油 高速増殖中"
  s.contentFurigana = "本醸造醤油 高速増殖中"
  s.contentMisconversion = "なし"
end

Sentence.seed do |s|
  s.id = 7
  s.content = "肩固かったから買った肩たたき機 肩たたきにくかった"
  s.contentFurigana = "肩固かったから買った肩たたき機 肩たたきにくかった"
  s.contentMisconversion = "あり,肩固かったから買った肩叩き機 肩叩きにくかった"
end

Sentence.seed do |s|
  s.id = 8
  s.content = "竹垣に竹立てかけたかったから竹立てかけた"
  s.contentFurigana = "<ruby>竹垣<rp>（</rp><rt>たけがき</rt><rp>）</rp></ruby>に竹立てかけたかったから竹立てかけた"
  s.contentMisconversion = "なし"
end

Sentence.seed do |s|
  s.id = 9
  s.content = "左折車専用車線 右折車が逆走"
  s.contentFurigana = "左折車専用車線 右折車が逆走"
  s.contentMisconversion = "あり,左折者専用車線 右折者が逆走"
end

Sentence.seed do |s|
  s.id = 10
  s.content = "商社の社長が 調査書捜査中"
  s.contentFurigana = "商社の社長が 調査書捜査中"
  s.contentMisconversion = "あり,商社の社長が 調査書操作中"
end

Sentence.seed do |s|
  s.id = 11
  s.content = "東京特許許可局 許可局長の許可"
  s.contentFurigana = "東京特許許可局 許可局長の許可"
  s.contentMisconversion = "なし"
end

Sentence.seed do |s|
  s.id = 12
  s.content = "ブスバスガイド バスガス爆発"
  s.contentFurigana = "ブスバスガイド バスガス爆発"
  s.contentMisconversion = "なし"
end

Sentence.seed do |s|
  s.id = 13
  s.content = "よぼよぼ病予防病院予防病室"
  s.contentFurigana = "よぼよぼ病予防病院予防病室"
  s.contentMisconversion = "あり,よぼよぼ秒予防病院予防病室"
end

Sentence.seed do |s|
  s.id = 14
  s.content = "レモンとメロンをレミオロメン ルミオンで食す"
  s.contentFurigana = "レモンとメロンをレミオロメン ルミオンで<ruby>食<rp>（</rp><rt>しょく</rt><rp>）</rp></ruby>す"
  s.contentMisconversion = "なし"
end

Sentence.seed do |s|
  s.id = 15
  s.content = "笑わば笑え わらわは笑われる謂れはない"
  s.contentFurigana = "笑わば笑え わらわは笑われる<ruby>謂<rp>（</rp><rt>いわ</rt><rp>）</rp></ruby>れはない"
  s.contentMisconversion = "あり,笑わば笑え 笑わは笑われる謂れはない,笑わば笑え わらわは笑われるいわれはない,笑わば笑え 笑わは笑われるいわれはない"
end

Sentence.seed do |s|
  s.id = 16
  s.content = "京の生鱈 奈良生まな鰹"
  s.contentFurigana = "京の<ruby>生鱈<rp>（</rp><rt>なまだら</rt><rp>）</rp></ruby> 奈良生まな<ruby>鰹<rp>（</rp><rt>がつお</rt><rp>）</rp></ruby>"
  s.contentMisconversion = "あり,きょうのなまだらならなままながつお"
end
