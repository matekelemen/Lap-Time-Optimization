function pass = brakeCheck_test()

    % Model setup
    evaluator                           = Evaluator();
    evaluator.targetFunction            = @objective_lapTime_rateLimitedBrakeCheck;
    evaluator.maxVelocityFunction       = @(curv)   100*( max(1-curv,0.01) );
    evaluator.maxAccelerationFunction   = @(v)      10*ones(size(v));
    evaluator.maxDecelerationFunction   = @(v)      -20*ones(size(v));
    evaluator.nSubdivisions             = 11;
    evaluator.startVelocity             = 0;
    
    evaluator.writeDetails              = true;

    % Create straight path
    Lx          = 1000;
    pathPoints  = [ linspace(0,Lx,101)', zeros(101,1) ];
    
    % Add disturbance to end point
    pathPoints  = [pathPoints;                                          ...
        Lx+1e-10,   0;                                                  ...
        Lx+2e-10,   0;                                                  ...
        Lx+3e-10,   0;                                                  ...
        Lx+3e-10,   1];
    
    [splx,sply] = cubicSpline2D(pathPoints);
    
    % Evaluate path
    evaluator.targetFunction(splx,sply,evaluator);
    
    % Check velocities
    pass        = true;
    tolerance   = 1e-10;
    for k=1:length(evaluator.velocities)
        if evaluator.velocities(k)-tolerance > evaluator.maxVelocityFunction(evaluator.curvatures(k))
            pass = false;
            break;
        end
    end

end