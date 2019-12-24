function track = track_MCityBlock(varargin)

    if ~isempty(varargin)
        refinement  = varargin{1};
    else
        refinement  = 1.0;
    end

    data    = csvread('MCity_bound1.csv');
    xIn     = data(:,1);
    yIn     = -data(:,2);

    data    = csvread('MCity_bound2.csv');
    xOut    = data(:,1);
    yOut    = -data(:,2);

    [splxIn,splyIn]     = cubicSpline2D([xIn,yIn]);
    [t,track.bound1]    = closestPointOnSpline(splxIn,splyIn,[xOut,yOut]);

    track.bound1        = pointOnSpline(splxIn,splyIn,t);
    track.bound2        = [xOut,yOut];
    track.center        = 0.5 * (track.bound1+track.bound2);
    
    % Make the bounds a bit narrower
    shrinkRatio         = 0.8;
    track.bound1        = shrinkRatio*track.bound1 + (1-shrinkRatio)*track.center;
    track.bound2        = shrinkRatio*track.bound2 + (1-shrinkRatio)*track.center;

    track.staticPoints  = [1,length(track.bound1)];

    track = redistributePointsOnTrack(track,refinement);

end