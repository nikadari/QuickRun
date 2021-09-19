const express = require('express')
const app = express()
const port = 3000

const firebase = require('./firebase.js');

function error(status, msg) {
  var err = {
    status,
    msg
  };
  return JSON.stringify(err);
}

// Middleware and authentication for the api.
/*app.use('/api', function(req, res, next){
  var key = req.query['password'];

  // key isn't present
  if (!key) return next(error(400, 'password required'));

  // key is invalid
  if (key != "Dolphin50") return next(error(401, 'invalid password'));

  // all good, store req.key for route access
  req.key = key;
  next();
});
*/

// Firebase gives you complete control over authentication by allowing you to authenticate users or devices using secure JSON Web Tokens (JWTs).
// You generate these tokens on your server, pass them back to a client device, and then use them to authenticate via the signInWithCustomToken()
// method.

app.get('/login', (req, res) => {
  let email = req.query['email'];
  let password = req.query['password'];
  firebase.Login(email, password).then((userRecord) => {
    res.json(userRecord);
  }).catch((error) => {
    res.json(error);
  });
});

// Okay, but then how do we serve a statically generated site, as
// if we were a CDN?
// This is the frontend for D.E.X.T.E.R.
app.use(express.static('public'));

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})
