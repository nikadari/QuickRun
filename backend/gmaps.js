const {Client, TravelMode} = require("@googlemaps/google-maps-services-js");
const API_KEY = process.env.KEY;
const client = new Client({});

const diameter = 10; //Diameter in # of nodes

module.exports = {
  genGraph: function(center, size){
      var location = Object.assign({}, center);

      var originString = "";
      var destinationString = "";

      var grid = new Array();

      //1 degree lat/lng is ~100000m

      let interval = size / diameter;
      let radius = diameter / 2;


      //move top left to bottom right, origin is always first
      for(let i = 0 - radius; i < radius; i++){
          for(let j = 0 - radius; j < radius; j++){
              grid.push({lat:parseFloat(center.lat) + (i * interval / 100000), lng: parseFloat(center.lng) + (j * interval / 100000)});
          }
      }

      return grid;
  }
}

//genGraph({lat: 0, lng:0}, 1000,TravelMode.bicycling)
