// Chrome と Firefox 両方に対応する
const recognition = new webkitSpeechRecognition() || new SpeechRecognition();

const timer = document.getElementById('timer');
const sentence = document.getElementById('sentence');
const notice = document.getElementById('notice');
const scoreOut = document.getElementById('scoreOut');
const rec = document.getElementById('rec');
const reading = document.getElementById('reading');
const stop = document.getElementById('stop');

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