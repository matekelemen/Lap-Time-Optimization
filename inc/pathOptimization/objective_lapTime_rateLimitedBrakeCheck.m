function t = objective_lapTime_rateLimitedBrakeCheck(splx,sply,evaluator)
    % t = objective_lapTime_rateLimitedBrakeCheck(splx,sply,tspan,evaluator)
    % Works only for the entire tspan [0,1]
    
    % Inverse evaluator
    invEvaluator                            = Evaluator();
    invEvaluator.maxAccelerationFunction    = @(v) -evaluator.maxDecelerationFunction(v);
    invEvaluator.maxDecelerationFunction    = @(v) -evaluator.maxAccelerationFunction(v);
    
    % Init
    n               = evaluator.nSubdivisions;
    tspan           = linspaceChain(splx.breaks,n)';
    t               = zeros(size(tspan));
    velocity        = zeros(size(tspan));
    velocity(1)     = evaluator.lastVelocity;
    
    % Curvatures and arc lengths
    curv            = curvature(splx,sply,tspan);
    arcLen          = arcLength(splx,sply,tspan);
    
    % Pointwise maximum velocities (based on curvatures)
    vMax            = evaluator.maxVelocityFunction(curv);
    
    % Going backwards, recalculate the maximum velocities based on
    % reversing the deceleration
    for k=length(tspan)-1:-1:1
        if vMax(k+1) < vMax(k)
            vMax(k) = vMax(k+1) + rateLimiter(                          ...
                vMax(k+1),                                              ...
                vMax(k),                                                ...
                arcLen(k+1)-arcLen(k),                                  ...
                invEvaluator);
        end
    end
    
    % Calculate velocities and elapsed time
    for k=2:length(tspan)
        % Calculate new velocity
        velocity(k) = velocity(k-1) + rateLimiter(                      ...
            velocity(k-1),                                              ...
            vMax(k),                                                    ...
            arcLen(k)-arcLen(k-1),                                      ...
            evaluator                                                   ...
            );
        % Calculate time
        t(k) = t(k-1) +                                                 ...
            2 * (arcLen(k) - arcLen(k-1))                               ...
            / ( velocity(k) + velocity(k-1)                             ...
            );
    end
    
    % Update evaluator structure
    if evaluator.writeDetails
        evaluator.lastVelocity  = velocity(end);
        evaluator.velocities    = velocity;
        evaluator.curvatures    = curv;
        evaluator.time          = t;
        evaluator.splineParams  = tspan;
    end
    
    % Get segment time (last in the vector)
    t = t(end);

end