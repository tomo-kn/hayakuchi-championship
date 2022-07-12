// Chrome と Firefox 両方に対応する
const recognition = new webkitSpeechRecognition() || new SpeechRecognition();

const timer = document.getElementById('timer');
const sentence = document.getElementById('sentence');
const notice = document.getElementById('notice');
const scoreOut = document.getElementById('scoreOut');
const rec = document.getElementById('rec');
const reading = document.getElementById('reading');
const stop = document.getElementById('stop');
const sentences = document.getElementById('sentences').value;
const sentencesId = document.getElementById('sentencesId').value;
const sentencesContent = document.getElementById('sentencesContent').value;
const sentencesSize = document.getElementById('sentencesSize').value;

const kotoba = document.getElementById('kotoba');
const seido = document.getElementById('seido');

recognition.lang = 'ja-JP';
recognition.interimResults = true;

// カウントダウン
let originTime = 90;
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

var hundleSuccess = (function(stream) {
  rec.disabled = true;
  nowRecordingMessage();
  // 話し始めたら録音中…と表示し、話が終わったら自動でstopしてくれる。
  recognition.addEventListener('speechstart', function() {
    console.log("開始しました")
    notice.innerHTML = '録音中…';
  });
  recognition.addEventListener('speechend', function() {
    stop.click();
  });
})

// 停止
stop.onclick = function() {
  console.log("停止しました");
}

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

console.log(sentences);
console.log(sentencesId);
console.log(sentencesContent);
console.log(sentencesContent.length);
console.log(sentenceIndexArray);
console.log(sentenceIndexArrayShuffled);

// シャッフルされた配列を用いてお題をランダムに取得し、表示する
let index = 0;
function selectSentence() {
  let selectIndex = sentenceIndexArrayShuffled[index % sentencesSize] - 1;
  console.log(selectIndex);
  let sentenceTemporary = sentencesContent[selectIndex];
  console.log(sentenceTemporary);
  index += 1
}

selectSentence();
selectSentence();
selectSentence();
selectSentence();
selectSentence();


recognition.onresult = function(e){
  reading.innerHTML = '';
  for (let i = e.resultIndex; (i < e.results.length); i++){
    let product = e.results[i][0].transcript;
    let confidence = e.results[i][0].confidence;
    if(e.results[i].isFinal){
      kotoba.innerHTML += product;
      seido.innerHTML += confidence;
      console.log(e);
    } else {
      reading.innerHTML += product;
    }
  }
};