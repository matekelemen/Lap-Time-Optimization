function track = track_LBend(varargin)
    % track = track_LBend(varargin)
    % Returns a track structure
    % Optional argument: refinement for track point redistribution
    
    baseRefinement  = 1.0;
    
    if nargin>0
        refinement  = varargin{1} * baseRefinement;
    else
        refinement  = baseRefinement;
    end

    % Initial point and heading
    track.lastPoint = [0,0];
    track.lastHeading = [0;1];
    % Build an L-bend
    track = buildTrack( track, [0,10],      @(x) 2 );
    track = buildTrack( track, [15,-pi/2],  @(x) 2 );
    track = buildTrack( track, [0,5],       @(x) 2 );
    
    % Restructure the distribution of points
    track = redistributePointsOnTrack( track, refinement );
    
end