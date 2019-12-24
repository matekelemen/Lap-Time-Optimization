function track = track_DemoTrack1(varargin)
    % track = track_DemoTrack1(varargin)
    % Returns a track structure
    % Optional argument: refinement for track point redistribution

    % Init
    track.lastPoint     = [0,0];
    track.lastHeading   = [1;0];
    
    baseRefinement      = 0.15;
    
    if nargin>0
        refinement  = varargin{1} * baseRefinement;
    else
        refinement  = baseRefinement;
    end
    
    % Scaling factor
    c                   = 3.0;
    
    % Define width functions
    w1                  = 1.5*c;
    w2                  = 3*c;

    W1                  = @(x) w1;
    W2                  = @(x) w2;
    W12                 = @(x) w1 + x*(w2-w1);
    W21                 = @(x) w2 + x*(w1-w2);
    % Initial point and heading
    track.lastPoint     = [0,0];
    track.lastHeading   = [0;1];
    % Build an L-bend (see trackTest)
    track               = buildTrack( track, [0,c*35],      W2 );
    track               = buildTrack( track, [c*7,-pi/4],   W2 );
    track               = buildTrack( track, [c*15,pi/4],   W2 );
    track               = buildTrack( track, [c*15,-pi],    W21 );
    track               = buildTrack( track, [0,c*70],      W1 );
    track               = buildTrack( track, [c*15,-pi/2],  W1 );
    radius = abs(track.center(1,1) - track.center(end,1));
    track               = buildTrack( track, [radius,-pi/2],W12 );
    len = abs(track.center(1,2) - track.center(end,2));
    track               = buildTrack( track, [0,len],       W2 );

    % Restructure the distribution of points
    track = redistributePointsOnTrack( track, refinement );

end