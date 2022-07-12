// Chrome と Firefox 両方に対応する
const recognition = new webkitSpeechRecognition() || new SpeechRecognition();

const timer = document.getElementById('timer');
const sentence = document.getElementById('sentence');
const notice = document.getElementById('notice');
const scoreOut = document.getElementById('scoreOut');
const rec = document.getElementById('rec');
const reading = document.getElementById('reading');
const stop = document.getElementById('stop');

recognition.lang = 'ja-JP';
recognition.interimResults = true;

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