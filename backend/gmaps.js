const {Client, TravelMode} = require("@googlemaps/google-maps-services-js");
const API_KEY = process.env.KEY;
const client = new Client({});

const diameter = 10; //Diameter in # of nodes

function genGraph(center, size, travelMode){
    var location = Object.assign({}, center);
    
    var originString = "";
    var destinationString = "";

    //1 degree lat/lng is ~100000m 

    let interval = size / diameter;
    let radius = diameter / 2;


    //move top left to bottom right, origin is always first
    for(let i = 0 - radius; i < radius; i++){ 
        for(let j = 0 - radius; j < radius; j++){
            originString += (center.lat + (i * interval / 100000)) + "%2C" + (center.lng + (j * interval / 100000)) + "%7C";
            destinationString += (center.lat + ((i + 1) * interval / 100000)) + "%2C" + (center.lng + ((j + 1)* interval / 100000)) + "%7C";
        }
    }

    //Remove extra '|' 
    originString = originString.substring(0, originString.length - 3);
    destinationString = destinationString.substring(0, destinationString.length - 3);

    //Log originString and destinationString
    console.log(originString + "\n" + destinationString);

    client
        .distancematrix({
        params: {
            mode: travelMode,
            origins: [{lat:0,lng:0}],
            destinations: [{lat:1,lng:0}],
            key: API_KEY,
        },
        timeout: 1000, // milliseconds
    })
    .then((r) => {
        console.log(r.data.results[0].elevation);
    })
    .catch((e) => {
        console.log(e);
    });
}

genGraph({lat: 0, lng:0}, 1000,TravelMode.bicycling)

function graphCallback(){

}