%%Read the gpx files

hhIn=gpxread("Estoril_Inner_bound.gpx");
hhOut=gpxread("Estoril_Outer_bound.gpx");

%%Convert Latitudes and Longitudes to x and y coordinates using deg2utm
%%function

[xIn,yIn,utmIn]=deg2utm(hhIn.Latitude,hhIn.Longitude);

[xOut,yOut,utmOut]=deg2utm(hhOut.Latitude,hhOut.Longitude);

%%Plot the two bounds

plot(xIn,yIn)
hold on
plot(xOut,yOut)
