import axios from 'axios';
axios.defaults.headers['X-Requested-With'] = 'XMLHttpRequest';
axios.defaults.headers['X-CSRF-TOKEN'] = document.getElementsByName('csrf-token')[0].getAttribute('content');

const recognition = new webkitSpeechRecognition();

const rec = document.getElementById('rec');
// const result = document.getElementById('result');

const text = document.getElementById('text');
const speeching = document.getElementById('speeching');
var recording = false;

recognition.lang = 'ja';
recognition.interimResults = true;
recognition.continuous = false;

const sound = document.getElementById('sound');
var mediaRecorder;

rec.addEventListener('click', function () {
  if(recording) {
    recording = false;
    recognition.stop();
  }else{
    recognition.start();
    recording = true;
    rec.textContent = "■";
    sound.textCountent = "Recording...";
    navigator.mediaDevices.getUserMedia({ audio: true, video: false }).then(hundleSuccess);
  }
});

recognition.onresult = function(e){
  speeching.innerText = '';
  for (let i = e.resultIndex; (i < e.results.length); i++){
    let result = e.results[i][0].transcript;
    if(e.results[i].isFinal){
      text.innerHTML += '<div>' + result + '</div>';
      console.log(e);
    }else{
      speeching.innerText += result;
      scrollBy(0, 50);
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

var hundleSuccess = function(stream){
  var recordedChunks = [];
  mediaRecorder = new MediaRecorder(stream);

  mediaRecorder.ondataavailable = function(e){
    if (e.data.size > 0){
      recordedChunks.push(e.data);
    }
  };

  mediaRecorder.onstop = function(){
    var d = new Date();
    var fn = ((((d.getFullYear()*100 + d.getMonth()+1)*100 + d.getDate())*100+ d.getHours())*100 + d.getMinutes())*100 + d.getMinutes();
    sound.href = URL.createObjectURL(new Blob(recordedChunks));
    sound.textContent = "Get Audio";
    sound.download = fn+".webm";
  };
  mediaRecorder.start();
};


recognition.addEventListener('soundstart', function() {
  console.log('Some sound is being received');
});

recognition.addEventListener('soundend', function(event) {
  console.log('Sound has stopped being received');
});