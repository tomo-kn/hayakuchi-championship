// Chrome と Firefox 両方に対応する
const recognition = new webkitSpeechRecognition() || new SpeechRecognition();

const timer = document.getElementById('timer');
const sentence = document.getElementById('sentence');
const notice = document.getElementById('notice');
const scoreTemporary = document.getElementById('scoreTemporary');
const outTemporary = document.getElementById('outTemporary');
const rec = document.getElementById('rec');
const reading = document.getElementById('reading');
const stop = document.getElementById('stop');
const sentencesContent = document.getElementsByName('sentencesContent');
const sentencesContentFurigana = document.getElementsByName('sentencesContentFurigana');
const sentencesContentMisconversion = document.getElementsByName('sentencesContentMisconversion');
const sentencesSize = document.getElementById('sentencesSize').value;
const scoreOut = document.getElementById('scoreOut');
const judge = document.getElementById('judge');
const restart = document.getElementById('restart');
const top = document.getElementById('top');
const twitter = document.getElementById('twitter');
const jsAnimation = document.getElementById('jsAnimation');
const batterImage = document.getElementById('batterImage');
const ranking = document.getElementById('ranking');

// 効果音
const gamesetSound = document.getElementById('gamesetSound');
const hitSound = document.getElementById('hitSound');
const homerunSound = document.getElementById('homerunSound');
const homerunsSound = document.getElementById('homerunsSound');
const outSound = document.getElementById('outSound');
const playballSound =  document.getElementById('playballSound');

// スタートページ関連
const startPage = document.getElementById('startPage');
const gamePage = document.getElementById('gamePage');
const startButton = document.getElementById('startButton');
const howToPlay = document.getElementById('howToPlay');
const howToPlayItems = document.getElementById('howToPlayItems');
const Notes = document.getElementById('Notes');
const NotesItems = document.getElementById('NotesItems');

// d-none関連
const kotoba = document.getElementById('kotoba');
const seido = document.getElementById('seido');
const odai = document.getElementById('odai');
const gohenkan = document.getElementById('gohenkan');

recognition.lang = 'ja-JP';
recognition.interimResults = true;

// ゲームスコア
let gameScore = 0;
let outScore = 0;
let homerunCount = 0;

// タイマーの初期値
let originTime = 61;
let timerID;

// ゲーム中であるか否かを判断するフラグ
let gameContinue = true;

// スタートボタン
startButton.onclick = function() {
  // 効果音とボタン以外の非表示
  playballSound.play();
  howToPlay.classList.add('d-none');
  howToPlayItems.classList.add('d-none');
  Notes.classList.add('d-none');
  NotesItems.classList.add('d-none');
  // ログイン時のみ、あるいは非ログイン時のみ表示しているブロックについてはif文で条件分岐して対応
  if(document.getElementById('loginAndMembership')) {
    const loginAndMembership = document.getElementById('loginAndMembership');
    loginAndMembership.classList.add('d-none');
  }
  if(document.getElementById('myScore')) {
    const myScore = document.getElementById('myScore');
    myScore.classList.add('d-none');
  }
  // スタートボタンを押したら1秒で初めのお題とカウントダウンを準備する。
  selectSentence();
  let startTime = new Date();
  timerID = setInterval(() => {
    timer.innerHTML = "  残り時間: " + (originTime - getTimerTime());
    // 制限時間を過ぎたらゲームセット関数を呼び出す 
    if(originTime - getTimerTime() <= 0) {
      gameSet();
    };
    // console.log(originTime - getTimerTime());
  }, 1000);
  function getTimerTime() {
    return Math.floor((new Date() - startTime) / 1000);
  }
  startButton.disabled = true;
  startButton.textContent = "プレイボール!!";
  gameContinue = true;
  // 1秒後に画面を切り替える
  setTimeout(() => {
    startPage.classList.add('d-none');
    gamePage.classList.remove('d-none');
    rec.click();
  }, 1000);
}

rec.onclick = function() {
  recognition.start();
  rec.textContent = "Now Recording…";
  navigator.mediaDevices.getUserMedia({ audio: true, video: false }).then(hundleSuccess);
}

var hundleSuccess = (function() {
  rec.disabled = true;
  // 話し始めたら録音中…と表示する。
  recognition.onspeechstart = function() {
    console.log("開始しました")
    notice.innerHTML = '録音中…';
    batterImage.src = 'hayakuchi-championship-batter1.png';
  };
  // result の処理
  recognition.onresult = function(e) {
    reading.innerHTML = '';
    for (let i = e.resultIndex; (i < e.results.length); i++){
      let product = e.results[i][0].transcript;
      let confidence = e.results[i][0].confidence;
      if(e.results[i].isFinal){
        kotoba.innerHTML = product;
        seido.innerHTML = confidence;
        console.log(e);
        reading.innerHTML = '読み取り結果';
      } else {
        reading.innerHTML += product;
      }
    }
  };
  // 話が終わったら自動でstopする。
  recognition.onspeechend = function() {
    // resultの処理を待つために0.5秒間遅延してみる
    notice.innerHTML = '～採点中～';
    setTimeout(() => {
      stop.click();
    }, 500)
  };
})

// 停止
stop.onclick = function() {
  console.log("停止しました");
  rec.textContent = "録音する";
  notice.innerHTML = 'お題を1回正しく発声しよう！';
  rec.disabled = false;
  recognition.stop();
  gradeText();
};

// 採点
function gradeText() {
  const accuracy = seido.innerHTML;
  const resultWord = kotoba.innerHTML.replace(/\s+/g, "");
  const sentenceWord = odai.innerHTML.replace(/\s+/g, "");

  console.log("精度: " + accuracy);
  console.log("あなたの言葉は、" + resultWord + "と聞こえました");

  // confidenceの威力を半分にする
  const accuracyFixed = Number(accuracy) + ((1 - Number(accuracy)) / 2.0);
  console.log("修正した精度: " + accuracyFixed);
  const scoreOriginal = Math.round((100 - levenshteinDistance(resultWord, sentenceWord)) * accuracyFixed * 10) / 10;
  console.log("scoreOriginal: " + scoreOriginal);
  // misconversionの処理
  var scoreMisconversion = 0;
  if(gohenkan.innerHTML != "なし"){
    var sentenceMisconversionArray = gohenkan.innerHTML.split(',');
    var scoreMisconversionAll = [];
    for (let i = 1; i < sentenceMisconversionArray.length; i++) {
      var sentenceMisconversionWord = sentenceMisconversionArray[i].replace(/\s+/g, "");
      console.log("誤変換ワード: " + sentenceMisconversionWord);
      scoreMisconversionAll.push(Math.round((100 - levenshteinDistance(resultWord, sentenceMisconversionWord)) * accuracyFixed * 10) / 10);
    }
    console.log("scoreMisconversionAll: " + scoreMisconversionAll);
    var scoreMisconversion = Math.max(...scoreMisconversionAll);
    console.log("scoreMisconversion: " + scoreMisconversion);
  };

  const score = Math.max(scoreOriginal, scoreMisconversion);
  console.log("スコアは、" + score + "点です。");

  // 95点以上はホームラン、90点以上はヒット、90点未満はアウト
  if(score >= 95){
    console.log("ホームラン！");
    gameScore += 2;
    homerunCount += 1;
    scoreTemporary.innerHTML = "Score: " + gameScore;
    batterImage.src = 'hayakuchi-championship-batter3.png';
    if(homerunCount <= 2){
      homerunSound.play();
    }
  } else if(score >= 90) {
    console.log("ヒット");
    gameScore += 1;
    homerunCount = 0;
    scoreTemporary.innerHTML = "Score: " + gameScore;
    batterImage.src = 'hayakuchi-championship-batter2.png';
    hitSound.play();
  } else {
    console.log("アウト…");
    outScore += 1;
    homerunCount = 0;
    if(outScore == 1){
      outTemporary.innerHTML = "  Out: " + "<span style='color:red'>●</span>";
      outSound.play();
    } else if(outScore == 2){
      outTemporary.innerHTML = "  Out: " + "<span style='color:red'>●●</span>";
      outSound.play();
    }
    batterImage.src = 'hayakuchi-championship-batter4.png';
  };
  // 3回連続ホームランの場合、残り時間に5秒追加のボーナス
  if(homerunCount == 3) {
    console.log("3回連続ホームランボーナス！残り時間5秒追加！");
    homerunCount = 0;
    originTime += 5;
    homerunsSound.play();
    jsAnimation.classList.add('is-show');
    setTimeout(() => {
      jsAnimation.classList.remove('is-show');
    }, 2000)
  };
  // ゲームが続行中の場合、以下の処理を行う
  if(gameContinue) {
    // アウトが3回重なったらゲームセット関数を呼び出す
    if(outScore == 3) {
      gameSet();
    } else {
      // 次のお題を選び録音ボタンを裏側で押す
      selectSentence();
      rec.click();
    };
  };
};

// ゲームセット関数
function gameSet() {
  gamesetSound.play();
  clearInterval(timerID);
  gameContinue = false;
  console.log("ゲームセット！");
  originTime = -1000;

  sentence.innerHTML = "<span style='color:red'>試合終了!!</span>";
  scoreOut.innerHTML = "スコア: " + gameScore + " - " + outScore;
  scoreOut.classList.remove("d-none");
  if((gameScore >= 14 && outScore <= 1) || gameScore >= 22) {
    judge.innerHTML = "あなたは一流の早口バッター！"
  } else if((gameScore >= 10 && outScore <= 2) || gameScore >= 16) {
    judge.innerHTML = "一流の早口バッターまでもう少し"
  } else {
    judge.innerHTML = "練習モードでたくさん訓練しよう"
  };
  judge.classList.remove("d-none");

  timer.classList.add('d-none');
  notice.classList.add('d-none');
  scoreTemporary.classList.add('d-none');
  outTemporary.classList.add('d-none');
  rec.classList.add('d-none');
  reading.classList.add('d-none');
  batterImage.classList.add('d-none');

  restart.classList.remove('invisible');
  top.classList.remove('invisible');

  // twitterのシェアボタン
  twitter.innerHTML += '<a  class="btn btn-outline-info" target="_blank" href="https://twitter.com/share?url=' + location.href + '&hashtags=早口言葉,早口言葉選手権&text=ゲームセット！%0a%0a試合結果は… ' + gameScore + ' - ' + outScore + 'でした！%0aみんなも挑戦しよう！%0a%0a"><i class="fab fa-twitter pe-1"></i>試合結果をつぶやく</a>';
  twitter.classList.remove("d-none");

  // ランキングページへのリンクを表示
  ranking.innerHTML += "<a href='/rank'>ランキングをチェック</a>";
  ranking.classList.remove('d-none');

  // ログイン時、かつgameScoreが1以上の場合のみデータを保存する
  if (document.getElementById('user') && gameScore >= 1) {
    const formScore = document.getElementById('score');
    const formOut = document.getElementById('out');
    formScore.value = gameScore;
    formOut.value = outScore;
  
    document.getElementById("submit").click();
  };
}

// レーベンシュタイン距離の定義
function levenshteinDistance( str1, str2 ) { 
  var x = str1.length; 
  var y = str2.length; 

  var d = []; 
  for( var i = 0; i <= x; i++ ) { 
      d[i] = []; 
      d[i][0] = i; 
  } 
  for( var i = 0; i <= y; i++ ) { 
      d[0][i] = i; 
  } 

  var cost = 0; 
  for( var i = 1; i <= x; i++ ) { 
      for( var j = 1; j <= y; j++ ) { 
          cost = str1[i - 1] == str2[j - 1] ? 0 : 1; 

          d[i][j] = Math.min( d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + cost ); 
      }
  }
  return d[x][y];
};

// 1～sentencesSize の配列を作る
let sentenceIndexArray = forRange(1, sentencesSize);
function forRange(a, z) {
  const lst = [];
    for (let i = a; i <= z; i++) {
        lst.push(i)
    }
    return lst;
};

// sentenceIndexArray の中身をシャッフルする
const sentenceIndexArrayShuffled = shuffle(sentenceIndexArray)
function shuffle([...array]) {
  for (let i = array.length - 1; i >= 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [array[i], array[j]] = [array[j], array[i]];
  }
  return array;
};

// シャッフルされた配列を用いてお題をランダムに取得し、表示する
let index = 0;
function selectSentence() {
  let selectIndex = sentenceIndexArrayShuffled[index % sentencesSize] - 1;
  console.log("次のお題の番号: " + selectIndex);
  let sentenceTemporary = sentencesContentFurigana[selectIndex].value;
  let sentenceOriginalTemporary = sentencesContent[selectIndex].value;
  let sentenceMisconversionTemporary = sentencesContentMisconversion[selectIndex].value;
  console.log("次のお題: " + sentenceOriginalTemporary);

  sentence.innerHTML = sentenceTemporary;
  odai.innerHTML = sentenceOriginalTemporary;
  gohenkan.innerHTML = sentenceMisconversionTemporary;

  index += 1
}

