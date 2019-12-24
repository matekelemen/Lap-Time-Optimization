function T = objective_lapTime_infiniteAcceleration(splx, sply, evaluator)
    % T = objective_lapTime_infiniteAcceleration(splx, sply, evaluator)

    % Init
    t           = linspaceChain(splx.breaks,evaluator.nSubdivisions);
    n           = length(t);
    T           = zeros(n,1);
    
    % Curvatures and arc lengths
    arcLen      = arcLength( splx, sply, t );
    curv        = curvature( splx, sply, t );
    
    % Get max velocities
    vMax        = evaluator.maxVelocityFunction(curv);
    
    % Calculate time
    for k=2:n
        T(k) = T(k-1) +                                                 ...
            2 * (arcLen(k) - arcLen(k-1))                               ...
            / ( vMax(k) + vMax(k-1) );
    end
    
    % Append curvatures
    if evaluator.writeDetails
        evaluator.lastVelocity  = vMax(end);
        evaluator.velocities    = vMax;
        evaluator.curvatures    = curv;
        evaluator.time          = T;
        evaluator.splineParams  = t;
    end
    
    %
    T = T(end);
    
end