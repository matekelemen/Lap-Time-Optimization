%%Read the gpx files

hhIn=gpxread("Hockenheimring_Bond1.gpx");
hhOut=gpxread("Hockenheimring_Bound2.gpx");

%%Convert Latitudes and Longitudes to x and y coordinates using deg2utm
%%function

[xIn,yIn,utmIn]=deg2utm(hhIn.Latitude,hhIn.Longitude);

[xOut,yOut,utmOut]=deg2utm(hhOut.Latitude,hhOut.Longitude);

%%Plot the two bounds

plot(xIn,yIn)
hold on
plot(xOut,yOut)
