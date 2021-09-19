/*const { initializeApp } = require('firebase/app');
const { getAuth, signInWithEmailAndPassword } = require("firebase/auth");

const firebaseConfig = {
  apiKey: "AIzaSyB5beQ3JbO1WQTW2pl88Xb_kVoJJuiEdT8",
  authDomain: "quickrun-d93aa.firebaseapp.com",
  projectId: "quickrun-d93aa",
  storageBucket: "quickrun-d93aa.appspot.com",
  messagingSenderId: "219586515002",
  appId: "1:219586515002:web:8ef7fccce6ecfbfaf9a503"
};

const app = initializeApp(firebaseConfig);
const auth = getAuth();
console.log(app);
*/

const {Firestore} = require('@google-cloud/firestore');

const firestore = new Firestore({
  projectId: "quickrun-d93aa",
  keyFilename: "./firebase_credentials.json"
});

/*collectionRef.add({foo: 'bar'}).then(docRef => {
  let firestore_loc = docRef.firestore;
  console.log(`Root location for document is ${firestore_loc.formattedName}`);
});
*/


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
      /*console.log('auth', auth);
      signInWithEmailAndPassword(auth, email, password).then((userCred) => {
        reesolve({userCred});
      }).catch((err) => {
        revoke({err});
      });*/

      admin.auth().getUserByEmail(email).then((userRecord) => {
        userRecordObj = userRecord.toJSON();
        // Want to generate a token and do secure things.
        // But simply supposing that the email and password are correct.
        let uid = userRecordObj.uid;
        resolve({uid});
      }).catch((error) => {
        revoke({error});
      });

    });
  },
  SignUp: async function(email, password, confirm_password) {
    return new Promise((resolve, revoke) => {
      if (password == confirm_password) {
        admin.auth().createUser({
          email,
          password
        }).then((userRecord) => {
          userRecordObj = userRecord.toJSON();
          let uid = userRecordObj.uid;
          admin.auth().createCustomToken(uid).then((customToken) => {
            resolve({customToken});
          }).catch((error) => {
            revoke({error});
          });
        }).catch((err) => {
          revoke({err});
        });
      } else {
        revoke({msg: "Password does not equal Confirm Password"});
      }
    })
  },
  GetDesiredActivityForUser: async function(uid) {
    try {
      let docRef = firestore.doc(uid + "/desiredActivity");
      let docSnap = await docRef.get();
      if (docSnap != undefined) {
        return docSnap.data();
      } else {
        throw "No document!";
      }
    } catch (err) {
      throw err;
    }
  },
  UpdateDesiredActivityForUser: async function(uid, desiredActivity) {
    try {
      let docRef = firestore.doc(uid + "/desiredActivity");
      await docRef.update({
        activityType: desiredActivity.activityType,
        pace: desiredActivity.pace,
        distance: desiredActivity.distance,
        time: desiredActivity.time
      });
      return "Updated desiredActivity doc for " + uid;
    } catch(err) {
      throw err;
    }
  }
};
