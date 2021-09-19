const {Client} = require("@googlemaps/google-maps-services-js");
const API_KEY = process.env.KEY;
const client = new Client({});

const diameter = 10; //Diameter in # of nodes

function genGraph(center, size){
    var location = Object.assign({}, center);
    
    var originString = "";

    //1 degree lat/lng is ~100000m 

    let interval = size / diameter;
    let radius = diameter / 2;


    //move top left to bottom right, origin is always first
    for(let i = 0 - radius; i < 0 + radius; i++){ 
        for(let j = 0 - radius; j < 0 + radius; j++){
            originString += center + (i * interval);
        }
    }

    client
        .distancematrix({
        params: {
            locations: [{ lat: 45, lng: -110 }],
            key: "asdf",
        },
        timeout: 1000, // milliseconds
    })
    .then((r) => {
        console.log(r.data.results[0].elevation);
    })
    .catch((e) => {
        console.log(e.response.data.error_message);
    });
}


function graphCallback(){

}