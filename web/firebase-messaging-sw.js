importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyDSn8BZKwVlECkh4VTV9MSwiPc8d8-GNqI",
  authDomain: "poll-and-play.firebaseapp.com",
  projectId: "poll-and-play",
  storageBucket: "poll-and-play.appspot.com",
  messagingSenderId: "629230451966",
  appId: "1:629230451966:web:c83a7e93264a2fc2c2f9af",
  measurementId: "G-KS3NQVT310"
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});