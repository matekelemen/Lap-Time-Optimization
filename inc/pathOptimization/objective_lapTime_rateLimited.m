function T = objective_lapTime_rateLimited(splx, sply, evaluator)
    % T = objective_lapTime_rateLimited(splx, sply, evaluator)

    % Init
    t           = linspaceChain(splx.breaks,evaluator.nSubdivisions);
    n           = length(t);
    velocity    = zeros(n,1);
    velocity(1) = evaluator.lastVelocity;
    T           = zeros(n,1);
    
    % Curvatures and arc lengths
    arcLen      = arcLength( splx, sply, t );
    curv        = curvature( splx, sply, t );
    
    % Maximum velocity
    vMax        = evaluator.maxVelocityFunction(curv);
    
    % Max velocities and elapsed time
    for k=2:n
        
        % Calculate new velocity
        velocity(k) = velocity(k-1) + rateLimiter(                      ...
            velocity(k-1),                                              ...
            vMax(k),                                                    ...
            arcLen(k)-arcLen(k-1),                                      ...
            evaluator                                                   ...
            );
        
        % Calculate time
        T(k) = T(k-1) +                                                 ...
            2 * (arcLen(k) - arcLen(k-1))                               ...
            / ( velocity(k) + velocity(k-1)                             ...
            );
        
    end
    
    % Update evaluator structure
    if evaluator.writeDetails
        evaluator.lastVelocity  = velocity(end);
        evaluator.velocities    = velocity;
        evaluator.curvatures    = curv;
        evaluator.time          = T;
        evaluator.splineParams  = t;
    end
    
    % Get elapsed time (last in the vector)
    T = T(end);
    
end