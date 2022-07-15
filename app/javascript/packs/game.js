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
const sentencesSize = document.getElementById('sentencesSize').value;

const kotoba = document.getElementById('kotoba');
const seido = document.getElementById('seido');

recognition.lang = 'ja-JP';
recognition.interimResults = true;

// ゲームスコア
let gameScore = 0;
let outScore = 0;
let homerunCount = 0;

// カウントダウン
let originTime = 91;
let startTime = new Date();
setInterval(() => {
  timer.innerHTML = "残り時間: " + (originTime - getTimerTime());
  // 制限時間を過ぎたらゲームセット関数を呼び出す 
  if(originTime - getTimerTime() == 0) {
    gameSet();
  };
}, 1000);

function getTimerTime() {
  return Math.floor((new Date() - startTime) / 1000);
}

let nowRecordingMessage = () => {
  notice.innerHTML = '～録音待機中～';
}

rec.onclick = function() {
  recognition.start();
  rec.textContent = "Now Recording…";
  navigator.mediaDevices.getUserMedia({ audio: true, video: false }).then(hundleSuccess);
}

var hundleSuccess = (function() {
  rec.disabled = true;
  nowRecordingMessage();
  // 話し始めたら録音中…と表示する。
  recognition.onspeechstart = function() {
    console.log("開始しました")
    notice.innerHTML = '録音中…';
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
  notice.innerHTML = '録音ボタンを押して1回繰り返そう！';
  rec.disabled = false;
  recognition.stop();
  gradeText();
};

// 採点
function gradeText() {
  const accuracy = seido.innerHTML;
  const resultWord = kotoba.innerHTML.replace(/\s+/g, "");
  const sentenceWord = sentence.innerHTML.replace(/\s+/g, "");

  console.log("精度: " + accuracy);
  console.log("あなたの言葉は、" + resultWord + "と聞こえました");

  const score = Math.round((100 - levenshteinDistance(resultWord, sentenceWord)) * accuracy * 10) / 10;
  console.log("スコアは、" + score + "点です。");

  // 95点以上はホームラン、90点以上はヒット、90点未満はアウト
  if(score >= 95){
    console.log("ホームラン！");
    gameScore += 2;
    homerunCount += 1;
    scoreTemporary.innerHTML = "Score: " + gameScore;
  } else if(score >= 90) {
    console.log("ヒット");
    gameScore += 1;
    homerunCount = 0;
    scoreTemporary.innerHTML = "Score: " + gameScore;
  } else {
    console.log("アウト…");
    outScore += 1;
    homerunCount = 0;
    outTemporary.innerHTML = "Out: " + outScore;
  };
  // 3回連続ホームランの場合、残り時間に5秒追加のボーナス
  if(homerunCount == 3) {
    console.log("3回連続ホームランボーナス！残り時間5秒追加！");
    homerunCount = 0;
    originTime += 5;
  };
  // アウトが3回重なったらゲームセット関数を呼び出す
  if(outScore == 3) {
    gameSet();
  } else {
    // ゲームが続行するのなら次のお題を選ぶ
    selectSentence();
  }
};

// ゲームセット関数
function gameSet() {
  console.log("ゲームセット！");
  originTime = -1000;
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
  let sentenceTemporary = sentencesContent[selectIndex].value;
  console.log("次のお題: " + sentenceTemporary);

  sentence.innerHTML = sentenceTemporary;
  index += 1
}

// 初めのお題(初期値)
var startSentence = true;
if(startSentence) {
  setTimeout(() => {
    selectSentence();
  }, 1000);
  startSentence = false;
};