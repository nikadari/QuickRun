const {Firestore} = require('@google-cloud/firestore');

const firestore = new Firestore({
  projectId: "quickrun-d93aa",
  keyFilename: "./firebase_credentials.json"
});

let collectionRef = firestore.collection('test');
console.log('collection ref',collectionRef);

collectionRef.add({foo: 'bar'}).then(docRef => {
  let firestore_loc = docRef.firestore;
  console.log(`Root location for document is ${firestore_loc.formattedName}`);
});

/*
var admin = require("firebase-admin");
let serviceAccount = require("./firebase_credentials.json");
admin.initializeApp({
    // Requires environment variable to be set, GOOGLE_APPLICATION_CREDENTIALS
    credential: admin.credential.cert(serviceAccount),
    databaseURL: 'https://<DATABASE_NAME>.firebaseio.com'
});


*/
