const express = require('express')
const app = express()
const port = 3000

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

app.get('/login', (req, res) => {
  res.json({ status: "201" })
});


// Okay, but then how do we serve a statically generated site, as
// if we were a CDN?
// This is the frontend for D.E.X.T.E.R.
app.use(express.static('public'));

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})
