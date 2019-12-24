function track = redistributePointsOnTrack (track, refinement, varargin)
    % track = redistributePointsOnTrack (track, refinement, varargin)
    %
    % Optional arguments:
    %   'section'           : index of section to be refined/redistributed,
    %                         if 0, all sections will be processed

    % Transpose points if necessary
    if size(track.center,2)>size(track.center,1)
        track.center = track.center';
    end
    if size(track.bound1,2)>size(track.bound1,1)
        track.bound1 = track.bound1';
    end
    if size(track.bound2,2)>size(track.bound2,1)
        track.bound2 = track.bound2';
    end
    
    % Variable arguments
    kwargs = containers.Map(                                            ...
        {'section'},                                                    ...
        { 0 }                                                           ...
    );
    for key=kwargs.keys
        key = key{1};
        index = find( strcmp(varargin(1:2:end), key) );
        if ~isempty(index)
            kwargs( key ) = varargin{index+1};
        end
    end
    
    % Redistribute points on track.bound1
    [track.center, centerSamples, track.staticPoints]   =               ...
        redistributePointsOnCurve(                                      ...
                                        track.center,                   ...
                                        refinement,                     ...
                                        'staticPoints',                 ...
                                        track.staticPoints,             ...
                                        'section',                      ...
                                        kwargs('section')               ...
                                        );
    n               = length(centerSamples);

    % Get splines through points
    [spl1x, spl1y]  = cubicSpline2D(track.bound1);
    [spl2x, spl2y]  = cubicSpline2D(track.bound2);
    
    [temp,track.bound1] = closestPointOnSpline(spl1x,spl1y,track.center);
    [temp,track.bound2] = closestPointOnSpline(spl2x,spl2y,track.center);
    
end