function track = track_DoubleBend(varargin)
    % track = track_DoubleBend(varargin)
    % Returns a track structure
    % Optional argument: refinement for track point redistribution

    % Init
    track.lastPoint     = [0,0];
    track.lastHeading   = [1;0];
    
    baseRefinement      = 1.2;
    
    if nargin>0
        refinement  = varargin{1} * baseRefinement;
    else
        refinement  = baseRefinement;
    end
    
    % Initial point and heading
    track.lastPoint = [0,0];
    track.lastHeading = [0;1];

    % Build a double bend (see trackTest)
    track = buildTrack( track, [0,10], @(x) 2 );
    track = buildTrack( track, [15,-pi/4], @(x) 2-x );
    track = buildTrack( track, [20,pi/4], @(x) 1+x );
    track = buildTrack( track, [0,5], @(x) 2 );

    % Restructure the distribution of points
    track = redistributePointsOnTrack( track, refinement );

end