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

// TODO: Read in the credentials at runtime? Maybe.
var admin = require("firebase-admin");
let serviceAccount = require("./firebase_credentials.json");
admin.initializeApp({
    // Requires environment variable to be set, GOOGLE_APPLICATION_CREDENTIALS
    credential: admin.credential.cert(serviceAccount)
});

module.exports = {
  Login: async function(email, password) {
    return new Promise((resolve, revoke) => {
      admin.auth().getUserByEmail(email).then((userRecord) => {
        userRecordObj = userRecord.toJSON();
        // Want to generate a token.
        // Supposing that the email and password are correct.
        let uid = userRecordObj.uid;
        admin.auth().createCustomToken(uid).then((customToken) => {
          resolve({customToken});
        }).catch((error) => {
          revoke({error});
        });
      }).catch((error) => {
        revoke({error});
      });

    });
  }
};
