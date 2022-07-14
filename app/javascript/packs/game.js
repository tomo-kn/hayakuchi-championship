// Chrome と Firefox 両方に対応する
const recognition = new webkitSpeechRecognition() || new SpeechRecognition();

const timer = document.getElementById('timer');
const sentence = document.getElementById('sentence');
const notice = document.getElementById('notice');
const scoreOut = document.getElementById('scoreOut');
const rec = document.getElementById('rec');
const reading = document.getElementById('reading');
const stop = document.getElementById('stop');
const sentencesContent = document.getElementsByName('sentencesContent');
const sentencesSize = document.getElementById('sentencesSize').value;

const kotoba = document.getElementById('kotoba');
const seido = document.getElementById('seido');

recognition.lang = 'ja-JP';
recognition.interimResults = true;

// カウントダウン
let originTime = 91;
let startTime = new Date();
setInterval(() => {
  timer.innerHTML = "残り時間: " + (originTime - getTimerTime()); 
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
  selectSentence();
};

// 採点
function gradeText() {
  const accuracy = seido.innerHTML;
  const resultWord = kotoba.innerHTML.replace(/\s+/g, "");
  const sentenceWord = sentence.innerHTML.replace(/\s+/g, "");

  console.log(accuracy);
  console.log(resultWord);

  const score = Math.round((100 - levenshteinDistance(resultWord, sentenceWord)) * accuracy * 10) / 10;
  console.log("スコアは、" + score + "点です。");

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
  console.log(selectIndex);
  let sentenceTemporary = sentencesContent[selectIndex].value;
  console.log(sentenceTemporary);

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