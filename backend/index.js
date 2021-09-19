const express = require('express')
var hbs = require('hbs') // Templating engine.

// Initialize the express js server.
const app = express()
app.set('view engine', 'hbs')
app.set('views', './public')

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

// There exists one webview for every user.
// use html templating to return a html page for viewing in the iframe?
// this way we can get a custom html each time based on the user.

// for now we are going to use the uid, for the purposes of testing.
// TODO: Use the custom generated token that users store for auth.
app.get('/api/path', (req, res) => {
  let lat = req.query['lat'];
  let lon = req.query['lon'];
  let uid = req.query['uid'];
  res.render('index');
});

app.get("/api/signup", (req, res) => {
  let email = req.query['email'];
  let password = req.query['password'];
  let confirm = req.query['confirm'];
  firebase.SignUp(email, password, confirm).then((userRecord) => {
    res.json(userRecord);
  });
});

// Okay, but then how do we serve a statically generated site, as
// if we were a CDN?
// This is the frontend for D.E.X.T.E.R.
app.use(express.static('public'));

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})
