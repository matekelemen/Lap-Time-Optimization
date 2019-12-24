function pass = rateLimiter_test()

    %% Unbounded velocity
    % Parameters
    L               = 1000;
    v0              = 0;
    accel           = 10;
    % Dynamics
    maxVelocity     = @(curv) Inf*ones(size(curv));
    % Evaluator setup
    evaluator                           = Evaluator();
    evaluator.nSubdivisions             = 11;
    evaluator.targetFunction        	= @objective_lapTime_rateLimited;
    evaluator.maxVelocityFunction       = maxVelocity;
    evaluator.maxAccelerationFunction   = @(v) accel;
    evaluator.maxDecelerationFunction   = @(v) -accel;
    evaluator.startVelocity             = v0;
    % Create track
    track.lastPoint     = [0,0];
    track.lastHeading   = [0;1];
    track               = buildTrack(track,[0,L],@(x)1);
    % Run calculation
    t = evaluatePath(                                                   ...
        track,                                                          ...
        0.5*ones(length(track.center),1),                               ...
        evaluator                                                       ...
        );
    % Analytical solution
    T = (sqrt(v0*v0+2*accel*L)-v0)/accel;
    % Check results
    if abs(t-T)>1e-1
        pass = false;
        return
    end
    %% Bounded velocity
    % Parameters
    vMax    = 300/3.6;
    % Reset
    evaluator.reset();
    % Redefine functions
    maxVelocity                         = @(curv) vMax*ones(size(curv));
    evaluator.maxVelocityFunction       = maxVelocity;
    % Run calculation
    t = evaluatePath(                                                   ...
        track,                                                          ...
        0.5*ones(length(track.center),1),                               ...
        evaluator                                                       ...
        );
    % Analytical solution
    t1  = (vMax-v0)/accel;
    T   = t1+(L-t1*(v0+accel/2*t1))/vMax;
    % Check results
    if abs(t-T)>1e-1
        pass = false;
        return
    end
    %%
    pass = true;
    
end