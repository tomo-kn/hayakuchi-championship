/** デバッグモードかどうか。本番URLが含まれている場合は自動でfalse */
var DEBUG_MODE = true && window.location.href.indexOf("https://hayakuchi-championship.com/") < 0;

/** デバッグモードでConsoleAPIが有効な場合にログを出力する */
function trace(s) {
  if (DEBUG_MODE && this.console && typeof console.log != "undefined") {
    console.log(s);
  }
}

// Chrome と Firefox 両方に対応する
const recognition = new webkitSpeechRecognition() || new SpeechRecognition();

const rec = document.getElementById('rec');
const notice = document.getElementById('notice');
const result = document.getElementById('result');
const playback = document.getElementById('playback');
const play = document.getElementById("play");
const restart = document.getElementById('restart');
const stop = document.getElementById('stop');
const downloadLink = document.getElementById('download');
const display = document.getElementById('display');
const judge = document.getElementById('judge');
const startTime = document.getElementById('startTime');
const endTime = document.getElementById('endTime');
const yourWord = document.getElementById('yourWord');
const game = document.getElementById('game');
const practices = document.getElementById('practices');
const twitter = document.getElementById('twitter');
const theme = document.getElementById('theme');
const sentenceFurigana = document.getElementById('sentenceFurigana').value;
const Notes = document.getElementById('Notes');
const NotesItems = document.getElementById('NotesItems');
const backToPractices = document.getElementById('backToPractices');

const kotoba = document.getElementById('kotoba');
const seido = document.getElementById('seido');

recognition.lang = 'ja-JP';

// 録音中か否かのフラグ
let recordingNow = true;

// for audio
let audio_sample_rate = null;
let audioContext = null;
let scriptProcessor = null;
let mediaStreamSource = null;

// audio data
let audioData = [];
let bufferSize = 1024;
let micBlobUrl = null;
let audioBlob = null;

// お題をルビ振りで表示
theme.innerHTML = sentenceFurigana;

let nowRecordingMessage = () => {
  notice.innerHTML = '～録音待機中～';
}

let doneMessage = () => {
  notice.innerHTML = ' 録音完了！';
}

rec.onclick = function () {
  recognition.start();
  recordingNow = true;
  rec.textContent = "Now Recording…";
  Notes.classList.add('d-none');
  NotesItems.classList.add('d-none');
  backToPractices.classList.add('d-none');
  // ログイン時のみ、あるいは非ログイン時のみ表示しているブロックについてはif文で条件分岐して対応
  if (document.getElementById('loginAndMembership')) {
    const loginAndMembership = document.getElementById('loginAndMembership');
    loginAndMembership.classList.add('d-none');
  }
  if (document.getElementById('myScore')) {
    const myScore = document.getElementById('myScore');
    myScore.classList.add('d-none');
  }
  navigator.mediaDevices.getUserMedia({ audio: true, video: false }).then(hundleSuccess);
};

var hundleSuccess = (function (stream) {
  audioData = [];
  audioContext = new AudioContext();
  audio_sample_rate = audioContext.sampleRate;
  scriptProcessor = audioContext.createScriptProcessor(bufferSize, 1, 1);
  mediaStreamSource = audioContext.createMediaStreamSource(stream);
  mediaStreamSource.connect(scriptProcessor);
  scriptProcessor.onaudioprocess = onAudioProcess;
  scriptProcessor.connect(audioContext.destination);

  rec.disabled = true;
  nowRecordingMessage();

  // カウントダウン
  let originTime = 20;
  let countTime = new Date();
  let timerID;
  timerID = setInterval(() => {
    // 20秒経過したらstop処理を行う
    if (originTime - getTimerTime() == 0) {
      recordingNow = false;
      endTime.innerHTML += performance.now();
      stop.click();
      clearInterval(timerID);
      trace("20秒経過したので自動的に停止しました");
      recognition.stop();
    };
  }, 1000);
  function getTimerTime() {
    return Math.floor((new Date() - countTime) / 1000);
  }

  // 話し始めたら録音中…と表示し、話が終わったら自動でstopしてくれる。
  recognition.addEventListener('speechstart', function () {
    startTime.innerHTML += performance.now();
    trace("開始しました")
    notice.innerHTML = '録音中…';
  });
  recognition.addEventListener('speechend', function () {
    if (recordingNow) {
      recordingNow = false;
      endTime.innerHTML += performance.now();
      stop.click();
      clearInterval(timerID);
      trace("停止しました");
      recognition.stop();
    };
  });
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
stop.onclick = function () {
  doneMessage();
  rec.classList.add("d-none");
  result.classList.remove("d-none");
  play.classList.remove("d-none");
  restart.classList.remove("d-none");
  if (document.getElementById('saveCaution')) {
    const saveCaution = document.getElementById('saveCaution');
    saveCaution.classList.remove('d-none');
  }
  saveAudio();
};

// 再生
play.onclick = function (audioBlob) {
  if (micBlobUrl) {
    playback.src = micBlobUrl;
    // 再生終了時
    playback.onended = function () {
      playback.pause();
      playback.src = '';
    };
    // 再生
    playback.play();
  }
};

// WAVに変換
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
  audioBlob = new Blob([dataview], { type: 'audio/wav' });
  micBlobUrl = window.URL.createObjectURL(audioBlob);
  trace(dataview);

  let myURL = window.URL || window.webkitURL;
  let url = myURL.createObjectURL(audioBlob);
  downloadLink.href = url;
};

//保存
let saveAudio = function () {
  exportWAV(audioData);
  downloadLink.download = 'test.wav';
  audioContext.close().then(function () {
  });
};

// 結果の処理
result.onclick = function () {
  notice.innerHTML = '～結果発表～';
  result.classList.add("d-none");
  if (document.getElementById('saveCaution')) {
    saveCaution.classList.add('d-none');
  }
  const resultWord_original = kotoba.innerHTML;
  const sentence_original = document.getElementById('sentence').value;

  const resultWord = resultWord_original.replace(/\s+/g, "");
  const sentenceWord = sentence_original.repeat(3).replace(/\s+/g, "");

  trace("読み取り結果: " + resultWord);
  trace("元のワード3回繰り返し: " + sentenceWord);
  trace("レーベンシュタイン距離: " + levenshteinDistance(resultWord, sentenceWord));
  // 元のワードに対するスコアを計算
  const accuracy = seido.innerHTML;
  const scoreOriginal = Math.round((100 - levenshteinDistance(resultWord, sentenceWord)) * accuracy * 10) / 10;
  trace("scoreOriginal: " + scoreOriginal);

  var scoreMisconversion = 0;
  // misconversionの処理
  if (document.getElementById('sentenceMisconversion').value != "なし") {
    var sentenceMisconversion = document.getElementById('sentenceMisconversion').value;
    var sentenceMisconversionArray = sentenceMisconversion.split(',');
    var scoreMisconversionAll = [];
    for (let i = 1; i < sentenceMisconversionArray.length; i++) {
      var sentenceMisconversionWord = sentenceMisconversionArray[i].repeat(3).replace(/\s+/g, "");
      trace("誤変換ワード3回繰り返し: " + sentenceMisconversionWord);
      trace("レーベンシュタイン距離: " + levenshteinDistance(resultWord, sentenceMisconversionWord));
      // misconversionに対するscoreを計算
      scoreMisconversionAll.push(Math.round((100 - levenshteinDistance(resultWord, sentenceMisconversionWord)) * accuracy * 10) / 10);
    }
    trace("scoreMisconversionAll: " + scoreMisconversionAll);
    var scoreMisconversion = Math.max(...scoreMisconversionAll);
    trace("scoreMisconversion: " + scoreMisconversion);
  };

  // display
  const score = Math.max(scoreOriginal, scoreMisconversion);
  const time = Math.round((endTime.innerHTML - startTime.innerHTML) / 100) / 10;
  display.innerHTML += "スコア: " + score + "点(Time: " + time + "秒)";
  display.classList.remove("d-none");

  // judge
  if (score >= 95) {
    judge.innerHTML += "完璧です！"
  } else if (score >= 90) {
    judge.innerHTML += "良い発音ですね！"
  } else if (score >= 80) {
    judge.innerHTML += "概ね聞き取りやすいです"
  } else {
    judge.innerHTML += "頑張って訓練しましょう。"
  };
  judge.classList.remove("d-none");

  // yourWord
  yourWord.innerHTML += "あなたの言葉は、<span style='color:red'>" + resultWord + "</span>と聞こえました";
  yourWord.classList.remove("d-none");

  // 非ログイン時にloginRecommendationを表示
  if (document.getElementById('loginRecommendation')) {
    const loginRecommendation = document.getElementById('loginRecommendation');
    loginRecommendation.classList.remove('d-none');
  }

  // game,practices
  game.classList.remove("d-none")
  practices.classList.remove("d-none")

  // twitterのシェアボタン
  twitter.innerHTML += '<a  class="btn btn-outline-info" target="_blank" href="https://twitter.com/share?url=' + location.href + '&hashtags=早口言葉,早口言葉選手権&text=早口言葉【' + sentence_original + '】に挑戦しました！%0a%0a結果は… ' + score + '点/100点(Time: ' + time + '秒)でした！%0aみんなも挑戦しよう！%0a%0a"><i class="fab fa-twitter pe-1"></i>練習結果をつぶやく</a>'
  twitter.classList.remove("d-none")

  // ログイン時、かつscoreが0点より大きい場合のみデータを保存する
  if (document.getElementById('user') && score > 0) {
    // FormDataの用意
    const voiceform = document.getElementById('voiceform');
    const fd = new FormData(voiceform);
    // 値の設定
    fd.set('score', score);
    fd.set('time', time);
    fd.set('word', resultWord);
    fd.set('voice', audioBlob, 'voice.wav');
    trace([...fd.entries()]);
    // sentenceIdの取得
    const sentenceId = document.getElementById('sentenceId').value;
    // fetchで送信
    fetch(`/practices/${sentenceId}`, {
      method: 'post',
      body: fd,
    })
      .then((res) => {
        if (!res.ok) {
          throw new Error(`${res.status} ${res.statusText}`);
        }
        return res.blob();
      })
      .then((blob) => {
        // blob にレスポンスデータが入る
      })
      .catch((reason) => {
        trace(reason);
      });
  };
};

// レーベンシュタイン距離の定義
function levenshteinDistance(str1, str2) {
  var x = str1.length;
  var y = str2.length;

  var d = [];
  for (var i = 0; i <= x; i++) {
    d[i] = [];
    d[i][0] = i;
  }
  for (var i = 0; i <= y; i++) {
    d[0][i] = i;
  }

  var cost = 0;
  for (var i = 1; i <= x; i++) {
    for (var j = 1; j <= y; j++) {
      cost = str1[i - 1] == str2[j - 1] ? 0 : 1;

      d[i][j] = Math.min(d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + cost);
    }
  }
  return d[x][y];
};

// onresultの処理
recognition.onresult = function (e) {
  for (let i = e.resultIndex; (i < e.results.length); i++) {
    let product = e.results[i][0].transcript;
    let confidence = e.results[i][0].confidence;
    if (e.results[i].isFinal) {
      kotoba.innerHTML += product;
      seido.innerHTML += confidence;
      trace(e);
    }
  }
};
