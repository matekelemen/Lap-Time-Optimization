function objective = evaluatePath(track, params, evaluator)
    % objective = evaluatePath(track, params, evaluator)
    % Executes evaluator.targetFunction on the spline, defined by the 
    % path points. The target function must have the following arguments: 
    % [splineX, splineY, evaluator]

    % Init
    if size(params, 1) < size(params, 2)
        params = params';
    end
    
    % Reset evaluator data
    evaluator.reset;
    
    % Piece the params together (sections)
    if evaluator.optimRange>0
        rng         = track.staticPoints(evaluator.optimRange)          ...
                      :                                                 ...
                      track.staticPoints(evaluator.optimRange+1);
        temp        = evaluator.params;
        temp(rng)   = params;
        params      = temp;
    end
    
    % Build path spline from coefficients
    points = generatePathPoints(track.bound1, track.bound2, params);
    [splx, sply] = cubicSpline2D(points);
    % Compute objective
    objective = evaluator.targetFunction(                               ...
            splx,                                                       ...
            sply,                                                       ...
            evaluator                                                   ...
            );
    
    % Normalize
    objective = objective / evaluator.norm * evaluator.objectiveMultiplier;
        
end