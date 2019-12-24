function vMax = maxVelocityOnPoint(curv)
    % vMax = maxVelocityOnPoint(curvature)
    % Returns the maximum possible velocity of the vehicle on a point of
    % the track with specific parameters (curvature)
    
    % Init
    if size(curv,2)>size(curv,1)
        curv = curv';
    end
    
    % Parameters
    vMax    = 300/3.6;
    h       = 0.25;
    
    % Critical velocity for sliding
    vMax = min([                                                        ...
        vMax*ones(length(curv),1),                                      ... % <--- Top speed
        sqrt( 0.72*9.81 ./ (curv+1e-10) ),                              ... % <--- Critical velocity (slide)
        sqrt( 9.81./(curv+1e-10)/h )                                    ... % <--- Critical velocity (flip)
        ],[],2);

end