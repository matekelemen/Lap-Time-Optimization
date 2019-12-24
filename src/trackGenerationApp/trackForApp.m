function [xb1,yb1,xb2,yb2] = trackForApp(trackName)
%TRACKFORAPP Summary of this function goes here
%   Detailed explanation goes here

b1=strcat(trackName,'_Bound1.gpx');
b2=strcat(trackName,'_Bound2.gpx');
bound1=gpxread(b1);
bound2=gpxread(b2);

%%Convert Latitudes and Longitudes to x and y coordinates using deg2utm
%%function

[xb1,yb1,utmIn]=deg2utm(bound1.Latitude,bound1.Longitude);

[xb2,yb2,utmOut]=deg2utm(bound2.Latitude,bound2.Longitude);


end

