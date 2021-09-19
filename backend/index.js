const express = require('express')
var hbs = require('hbs') // Templating engine.

// Trying to fix a bug.
var cors = require('cors');
const gmaps = require("./gmaps.js");
const algorithm = require("./algorithm.js");

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

app.get("/signup", (req, res) => {
  let email = req.query['email'];
  let password = req.query['password'];
  let confirm = req.query['confirm'];
  firebase.SignUp(email, password, confirm).then((userRecord) => {
    res.json(userRecord);
  });
});

// There exists one webview for every user.
// use html templating to return a html page for viewing in the iframe?
// this way we can get a custom html each time based on the user.

app.get('/api/update/activity', (req, res) => {
  let uid = req.query['uid'];
  let activityType = req.query['type'];
  let pace = req.query['pace'];
  let distance = req.query['distance'];
  let time = req.query['time'];
  firebase.UpdateDesiredActivityForUser(uid, {
    activityType: parseInt(activityType),
    pace: parseFloat(pace),
    distance: parseFloat(distance),
    time: parseFloat(time)
  }).then((result) => {
    res.json({result});
  }).catch((err) => {
    res.json({err});
  });
})

// for now we are going to use the uid, for the purposes of testing.
// TODO: Use the custom generated token that users store for auth.
app.get('/api/path', (req, res) => {

  console.log('API');

  // For the data that will be stored in Firebase.
  // The formatting will be like so.
  // pace is a number in min/km, if the activity is selected as Run.
  // pace is in km/h if the activity is a cycle.
  // pace for walking will be canonical. Use the average human walking pace.
  // we will use min/km for this.
  // distance will be in km, always, regardless of activity.
  // time will be in minutes, always, regardless of activity.
  // since we either use distance or time in our calculations,
  // we need to know which one is the canoncial one.
  let lat = req.query['lat'];
  let lng = req.query['lon'];
  let uid = req.query['uid'];

  firebase.GetDesiredActivityForUser(uid).then((desiredActivity) => {

    console.log('desiredActivity', desiredActivity);
    // TODO: From the desired activity it is necessary to build the
    // correct path.

    let proper_path = algorithm.getpath({lat, lng}, desiredActivity.distance/2);
    /*let proper_path = [
      {
        lat: 44.229571,
        lon: -76.501460
      },
      {
        lat: 44.222516,
        lon: -76.500951
      },
      {
        lat: 44.227531,
        lon: -76.484051
      },
      {
        lat: 44.228585,
        lon: -76.487828
      }
    ];*/

    let l = proper_path.length;
    let last_waypoint = proper_path[l - 1];
    let waypoint_js = proper_path.slice(0, l - 1).map((waypoint) => {
      return "{location: new google.maps.LatLng(" + waypoint.lat + "," + waypoint.lon + "), stopover: true }";
    }).join(",");

    res.render('index', {
      lat,
      lon,
      dest_lat: last_waypoint.lat,
      dest_lon: last_waypoint.lon,
      waypoint_js
    });

  }).catch((error) => {
    res.send(JSON.stringify(error));
  });

});

app.get("/api/debug", (req, res) => {
  let lat = req.query['lat'];
  let lng = req.query['lon'];

  // get the proper_path via the algo in gmaps.js
  let graph = gmaps.genGraph({lat, lng}, 5000/2);
  console.log(graph);
  let N = graph[0].length;

  let proper_path = graph;

  /*
  for (let i = 0; i < N; i++) {
    for (let j = 0; j < N; j++) {
      proper_path.push(graph[i][j]);
    }
  }*/

  let l = proper_path.length;
  let waypoint_js = proper_path.map((waypoint) => {
    return "markers.push(new google.maps.Marker({position: { lat:" + waypoint.lat + ",lng:" + waypoint.lng + "},map}));";
  }).join("");
  res.render('debug', {
    lat,
    lng,
    waypoint_js
  });
});



// Okay, but then how do we serve a statically generated site, as
// if we were a CDN?
// This is the frontend for D.E.X.T.E.R.
app.use(express.static('public'));

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})
