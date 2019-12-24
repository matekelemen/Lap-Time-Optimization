function track = track_CircuitDeCatalunya(varargin)
    % track = track_CircuitDeCatalunya(varargin)
    % Returns a track structure
    % Optional argument: refinement for track point redistribution
    
    % Init
    track.lastPoint     = [0,0];
    track.lastHeading   = [1;0];
    
    baseRefinement      = 0.1;
    
    if nargin>0
        refinement  = varargin{1} * baseRefinement;
    else
        refinement  = baseRefinement;
    end

    % Width functions
    w1 = 12;
    w2 = 8;

    W1 = @(x) w1;               % w1        (constant)
    W2 = @(x) w2;               % w2        (constant)

    W21 = @(x)w2 + x*(w1-w2);   % w2->w1    (linear)
    W12 = @(x)w1 + x*(w2-w1);   % w1->w2    (linear)

    % ~Circuit de Catalunya
    track = buildTrack( track, [0,        1000],                W1 );
    track = buildTrack( track, [100,      -3*pi/8],             W1 );
    track = buildTrack( track, [0,        50],                  W1 );
    track = buildTrack( track, [150,      pi/4],                W1 );
    track = buildTrack( track, [0,        70],                  W1 );
    track = buildTrack( track, [150,      -pi/4],               W1 );
    track = buildTrack( track, [200,      -5*pi/8],             W1 );
    track = buildTrack( track, [0,        100],                 W1 );
    track = buildTrack( track, [100,      -pi],                 W1 );
    track = buildTrack( track, [0,        20],                  W1 );
    track = buildTrack( track, [50,       pi/2],                W1 );
    track = buildTrack( track, [80,       3*pi/8],              W1 );
    track = buildTrack( track, [0,        100],                 W1 );
    track = buildTrack( track, [50,       pi/8],                W1 );
    track = buildTrack( track, [0,        200],                 W1 );
    track = buildTrack( track, [50,       pi/2],                W1 );
    track = buildTrack( track, [0,        50],                  W1 );
    track = buildTrack( track, [100,      -pi/8],               W1 );
    track = buildTrack( track, [0,        200],                 W1 );
    track = buildTrack( track, [50,       -pi/2],               W1 );
    track = buildTrack( track, [0,        300],                 W1 );
    track = buildTrack( track, [35,       7*pi/8],              W1 );
    track = buildTrack( track, [0,        100],                 W1 );
    track = buildTrack( track, [75,       pi/8],                W1 );
    track = buildTrack( track, [70,       -7*pi/8],             W1 );
    track = buildTrack( track, [0,        300],                 W1 );
    track = buildTrack( track, [50,       -pi/2],               W1 );
    track = buildTrack( track, [0,        70],                  W1 );
    track = buildTrack( track, [40,       pi/2],                W1 );
    track = buildTrack( track, [60,       -pi/2],               W1 );
    track = buildTrack( track, [0,        367.9884],            W1 );
    track = buildTrack( track, [133.6596, -pi/2],               W1 );
    
    track = redistributePointsOnTrack( track, refinement );

end