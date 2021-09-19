//Make set of 10 waypoints to draw paths
const smoothing = 0.3;
const deadzone = 0.15;
const pull = 1;

function getPath(origin, desiredTravelDistance) {
  let numberOfNodesForPath = 5;
  let wypnts = waypoints(numberOfNodesForPath);
  let diameter = desiredTravelDistance * 1000 / 2; // travel distance is in km
  let interval = diameter / 10 / 100000;
  let geo_wypnts = convertGeo(waypoints(numberOfNodesForPath), origin, interval);
  return geo_wypnts;
}

// distance is the number of nodes.
function waypoints(distance) {
    var dX;
    var dY;

    //previous point
    var pX = 0;
    var pY = 0;

    //var position = [{lat:origin.lat, lng:origin.lng}];
    var position = {x:0, y:0};
    var waypoints = new Array();

    var distanceleft = distance;

    var returnIntent = false;

    do{
        waypoints.push(Object.assign({}, position));

        let cx = 0;
        let cy = 0;

        //smooth weighting
        let sx = (position.x - pX); //-1 to 1 weighting of direction
        let sy = (position.y - pX);

        //origin weighting
        let ox = -(position.x) / (distanceleft / 2); // -1 to 1, weighting of direction
        let oy = -(position.y) / (distanceleft / 2);

        //apply weighting
        cx += sx * smoothing;
        cy += sy * smoothing;
        cx += ox * pull;
        cy += oy * pull;
        cx = -cx;
        cy = -cy;


        //random number from -1 to 1
        let rx = Math.random() * 2 - 1;
        let ry = Math.random() * 2 - 1;

        pX = position.x;
        pY = position.y;

        let xChanged = 1;
        let yChanged = 1;

        if(Math.abs(rx) < deadzone || (position.x == 0 && returnIntent))
            xChanged = 0;
        else if((Math.random() * 2 - 1) < cx) //negative direction
            position.x--;
        else
            position.x++;

        if(Math.abs(ry) < deadzone || (position.y == 0 && returnIntent))
            yChanged = 0;
        else if((Math.random() * 2 - 1) < cy)
            position.y--;
        else
            position.y++;

        distanceleft = distanceleft - Math.sqrt(xChanged + yChanged); 

        if(distanceleft < 1){
            returnIntent = true;
            distanceleft = 1;
        }
        
        console.log("d:",xChanged,yChanged,distanceleft);
    } while(position.x != 0 || position.y != 0);

    waypoints.push(position);
    return waypoints;
}

//interval in degrees
function convertGeo(waypoints, origin, interval){
    var geowaypoints = new Array;

    for(let i = 0; i < waypoints.length; i++){
        let latitude = waypoints[i].x * interval + origin.lat;
        let longitude = waypoints[i].y * interval + origin.lng;

        geowaypoints.push({lat: latitude, lng: longitude});
    }
    return geowaypoints;
}

//console.log(waypoints(5));
// console.log(convertGeo(waypoints(5), {lat: 100, lng: 1}, 0.001));


/*
random dx, dy

smooth weighting
s = smoothing constant (between 0 and 1)
px= previous x coord

dx = (dx + (x - px)s)

origin weighting (0-2, where 1 is neutral)
dx = (x - x0) / (distanceleft / 4) -> weighted chance of heading towards origin
dy = (y - y0) / (distanceleft / 4)
*/
