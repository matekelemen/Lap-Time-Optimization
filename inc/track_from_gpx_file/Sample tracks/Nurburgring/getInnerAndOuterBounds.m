%%Read the gpx files

hhIn=gpxread("Nurburing_Bound1.gpx");
hhOut=gpxread("Nurburing_Bound2.gpx");

%%Convert Latitudes and Longitudes to x and y coordinates using deg2utm
%%function

[xIn,yIn,utmIn]=deg2utm(hhIn.Latitude,hhIn.Longitude);

[xOut,yOut,utmOut]=deg2utm(hhOut.Latitude,hhOut.Longitude);

%%Plot the two bounds

plot(xIn,yIn)
hold on
plot(xOut,yOut)
