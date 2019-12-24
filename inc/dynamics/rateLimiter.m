function dv = rateLimiter ( v0, v1, ds, evaluator )
    % dv = rateLimiter ( v0, v1, ds, evaluator )
    % Returns the velocity change of the vehicle based on the inputs
    % v0        : last velocity (magnitude)
    % v1        : current desired velocity (magnitude)
    % ds        : distance from previous point (path length since last point)
    % evaluator : evaluator with maxAccelerationFunction and
    %             maxDecelerationFunction

    % Calculate ideal acceleration
    dt = 2*ds / (v1+v0);
    
    if dt >= 0
        acceleration = (v1-v0) / dt;
    else
        acceleration = evaluator.maxAccelerationFunction(v0);
    end
    
    % Apply acceleration limit if necessary
    accelerationLimits  = [                                             ...
        evaluator.maxDecelerationFunction(v0),                          ...
        evaluator.maxAccelerationFunction(v0)                           ...
        ];                                                              ...
    if acceleration > accelerationLimits(2)
        acceleration = accelerationLimits(2);
    elseif acceleration < accelerationLimits(1)
        acceleration = accelerationLimits(1);
    end
    
    % Calculate elapsed time
    if acceleration ~= 0
        dt = sqrt( v0*v0 + 2*acceleration*ds );
        dt = sign(dt)*dt - v0;
        dt = dt / acceleration;
    else
        dt = ds/v0;
    end
    
    % Output velocity change
    dv = acceleration * dt;

end