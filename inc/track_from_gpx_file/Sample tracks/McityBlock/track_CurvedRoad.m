function track = track_CurvedRoad(varargin)

    baseRefinement  = 0.6;

    if nargin>0
        refinement  = varargin{1} * baseRefinement;
    else
        refinement  = baseRefinement;
    end

  
    CL = readmatrix('Centerline.csv');
    figure(1)
    plot(CL(:,1),CL(:,2))
    
    xC = CL(:,1);
    yC = CL(:,2);
    % Number of points on inner and outer bounds are not equal
    % -> resample based on the outer bound
    [splxC,splyC]     = cubicSpline2D([xC,yC]);
    plot(splxC,splyC)
    
    [t,track.bound1]    = closestPointOnSpline(splxIn,splyIn,[xOut,yOut]);
       
    track.bound1        = pointOnSpline(splxIn,splyIn,t);
    track.bound2        = [xOut,yOut];
    track.center        = 0.5 * (track.bound1+track.bound2);
    
    track.staticPoints  = [1,       ...
                           length(track.bound1)];
    
    track               = redistributePointsOnTrack(track,refinement);
    


end