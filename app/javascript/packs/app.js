const recognition = new webkitSpeechRecognition();

const rec = document.getElementById('rec');
const notice = document.getElementById('notice');
const result = document.getElementById('result');
const playback = document.getElementById('playback');
const play = document.getElementById("play")
const restart = document.getElementById('restart');
const stop = document.getElementById('stop');
const download = document.getElementById('download');

const text = document.getElementById('text');

var recording = false;

recognition.lang = 'ja';
recognition.interimResults = true;
recognition.continuous = false;

// for audio
let audio_sample_rate = null;
let audioContext = null;
let scriptProcessor = null;
let mediaStreamSource = null;

// audio data
let audioData = [];
let bufferSize = 1024;
let micBlobUrl = null;

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
  mediaStreamSource = audioContext.createMediaStreamSource(stream);
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

// 再生
play.onclick = function(audioBlob) {
  if (micBlobUrl) {
    playback.src = micBlobUrl;
    // 再生終了時
    playback.onended = function() {
      playback.pause();
      playback.src = '';
    };
    // 再生
    playback.play();
  }
};


//WAVに変換
let exportWAV = function (audioData) {
  let encodeWAV = function (samples, sampleRate) {
      let buffer = new ArrayBuffer(44 + samples.length * 2);
      let view = new DataView(buffer);

      let writeString = function (view, offset, string) {
          for (let i = 0; i < string.length; i++) {
              view.setUint8(offset + i, string.charCodeAt(i));
          }
      };

      let floatTo16BitPCM = function (output, offset, input) {
          for (let i = 0; i < input.length; i++, offset += 2) {
              let s = Math.max(-1, Math.min(1, input[i]));
              output.setInt16(offset, s < 0 ? s * 0x8000 : s * 0x7FFF, true);
          }
      };

      writeString(view, 0, 'RIFF');  // RIFFヘッダ
      view.setUint32(4, 32 + samples.length * 2, true); // これ以降のファイルサイズ
      writeString(view, 8, 'WAVE'); // WAVEヘッダ
      writeString(view, 12, 'fmt '); // fmtチャンク
      view.setUint32(16, 16, true); // fmtチャンクのバイト数
      view.setUint16(20, 1, true); // フォーマットID
      view.setUint16(22, 1, true); // チャンネル数
      view.setUint32(24, sampleRate, true); // サンプリングレート
      view.setUint32(28, sampleRate * 2, true); // データ速度
      view.setUint16(32, 2, true); // ブロックサイズ
      view.setUint16(34, 16, true); // サンプルあたりのビット数
      writeString(view, 36, 'data'); // dataチャンク
      view.setUint32(40, samples.length * 2, true); // 波形データのバイト数
      floatTo16BitPCM(view, 44, samples); // 波形データ
      return view;
  };

  let mergeBuffers = function (audioData) {
      let sampleLength = 0;
      for (let i = 0; i < audioData.length; i++) {
          sampleLength += audioData[i].length;
      }
      let samples = new Float32Array(sampleLength);
      let sampleIdx = 0;
      for (let i = 0; i < audioData.length; i++) {
          for (let j = 0; j < audioData[i].length; j++) {
              samples[sampleIdx] = audioData[i][j];
              sampleIdx++;
          }
      }
      return samples;
  };

  let dataview = encodeWAV(mergeBuffers(audioData), audio_sample_rate);
  let audioBlob = new Blob([dataview], { type: 'audio/wav' });
  micBlobUrl = window.URL.createObjectURL(audioBlob);
  console.log(dataview);

  let myURL = window.URL || window.webkitURL;
  let url = myURL.createObjectURL(audioBlob);
  download.href = url;
};



//保存
let saveAudio = function () {
  exportWAV(audioData);
  download.download = 'test.wav';
  audioContext.close().then(function () {
  });
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





