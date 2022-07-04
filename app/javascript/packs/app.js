const recognition = new webkitSpeechRecognition();

const rec = document.getElementById('rec');
const notice = document.getElementById('notice');
// const result = document.getElementById('result');

const text = document.getElementById('text');
const speeching = document.getElementById('speeching');
var recording = false;

recognition.lang = 'ja';
recognition.interimResults = true;
recognition.continuous = false;

const sound = document.getElementById('sound');
var mediaRecorder;

// for audio
let audio_sample_rate = null;
let audioContext = null;
let scriptProcessor = null;
let mediaStreamSource = null;


// audio data
let audioData = [];
let bufferSize = 1024;


let nowRecordingMessage = () => {
  notice.innerHTML = '～録音待機中～';
}

let doneMessage = () => {
  notice.innerHTML = ' 録音完了！';
}

rec.onclick = function() {
    recognition.start();
    recording = true;
    rec.textContent = "Now Recording…";
    navigator.mediaDevices.getUserMedia({ audio: true, video: false }).then(hundleSuccess);
};

var hundleSuccess = (function(stream){
  rec.disabled = true;
  audioData = [];
  audioContext = new AudioContext();
  audio_sample_rate = audioContext.sampleRate;
  scriptProcessor = audioContext.createScriptProcessor(bufferSize, 1, 1);
  mediaStreamSource = audioContext.createMediaStreamSource;
  mediaStreamSource.connect(scriptProcessor);
  scriptProcessor.onaudioprocess = onAudioProcess;
  scriptProcessor.connect(audioContext.destination)

  nowRecordingMessage();
  // 話し始めたら録音中…と表示し、話が終わったら自動でstopしてくれる。
  recognition.onspeechstart = function() {
    console.log("開始しました")
    notice.innerHTML = '録音中…';
  }
  recognition.onspeechend = function() {
    stop.click();
  }
}).catch(function (error) { // error
  console.error('mediaDevice.getUserMedia() error:', error);
  return;
});

// save audio data //1024bitのバッファサイズに達するごとにaudioDataにデータを追加する
var onAudioProcess = function (e) {
  var input = e.inputBuffer.getChannelData(0);
  var bufferData = new Float32Array(bufferSize);
  for (var i = 0; i < bufferSize; i++) {
      bufferData[i] = input[i];
  }
  audioData.push(bufferData);
};

// 停止
stop.onclick = function() {
  doneMessage();
  console.log("停止しました");
  rec.classList.add("d-none");
  result.classList.remove("d-none");
  play.classList.remove("invisible");
  restart.classList.remove("invisible");
  saveAudio();
};


recognition.onresult = function(e){
  for (let i = e.resultIndex; (i < e.results.length); i++){
    let result = e.results[i][0].transcript;
    if(e.results[i].isFinal){
      text.innerHTML += '<div>' + result + '</div>';
      console.log(e);
    }
  }
};

recognition.onend = function(){
  if(recording){
    recognition.start();
  }else{
    rec.textContent = "●";
    mediaRecorder.stop();
  }
};




