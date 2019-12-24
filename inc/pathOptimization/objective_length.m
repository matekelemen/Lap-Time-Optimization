function lineInt = objective_length(splx, sply, evaluator)
    % lineInt = objective_length(splx, sply, evaluator)
    % Returns the length of the spline
        
    % Calculate line integral
    lineInt = diff( arcLength(splx,sply,[0,1]) );
    
    if evaluator.writeDetails
        evaluator.splineParams  = t;
    end
        
end