function track = track_Nurburgring(varargin)

    baseRefinement  = 0.6;

    if nargin>0
        refinement  = varargin{1} * baseRefinement;
    else
        refinement  = baseRefinement;
    end

    % Read the gpx files
    hhIn=gpxread('inc/track_from_gpx_file/Sample Tracks/Nurburgring/Nurburgring_Bound1.gpx');
    hhOut=gpxread('inc/track_from_gpx_file/Sample Tracks/Nurburgring/Nurburgring_Bound2.gpx');

    % Convert Latitudes and Longitudes to x and y coordinates
    [xIn,yIn,utmIn]=deg2utm(hhIn.Latitude,hhIn.Longitude);
    [xOut,yOut,utmOut]=deg2utm(hhOut.Latitude,hhOut.Longitude);
    
    % Number of points on inner and outer bounds are not equal
    % -> resample based on the outer bound
    [splxIn,splyIn]     = cubicSpline2D([xIn,yIn]);
    [t,track.bound1]    = closestPointOnSpline(splxIn,splyIn,[xOut,yOut]);
       
    track.bound1        = pointOnSpline(splxIn,splyIn,t);
    track.bound2        = [xOut,yOut];
    track.center        = 0.5 * (track.bound1+track.bound2);
    
    track.staticPoints  = [1,       ...
                           length(track.bound1)];
    
    track               = redistributePointsOnTrack(track,refinement);
    
%     hold on
%     for k=1:length(track.bound1)
%         if mod(k,2)==0
%             lineSpec    = 'r.';
%         else
%             lineSpec    = 'b.';
%         end
%         plot(                                                           ...
%             track.bound1(k,1), track.bound1(k,2), lineSpec,             ...
%             track.bound2(k,1), track.bound2(k,2), lineSpec,             ...
%             track.center(k,1), track.center(k,2), lineSpec              ...
%             );
%     end

end