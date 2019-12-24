% Class definition that makes sure that Evaluator objects get passed by
% reference

classdef Evaluator < handle
  properties
    targetFunction                  % function called by evaluatePath
    maxVelocityFunction             % maximum possible velocity function
    maxAccelerationFunction         % maximum possible acceleration function
    maxDecelerationFunction         % maximum possible deceleration function
    lastVelocity                    % (internal)
    startVelocity                   % initial velocity
    velocities                      % velocities at all evaluated points
    curvatures                      % curvatures at all evaluated points
    time                            % time at all evaluated points
    splineParams                    % parameter values at which the spline is sampled
    norm                            % objective value at the center line
    objectiveMultiplier             % constant to multiply the objective with after normalization
    optimRange                      % index of the track section to be optimized
                                    % 0 stands for the entire track
    params                          % solution parameters
    nSubdivisions                   % number of subdivisions per spline 
                                    % segments during computation
    writeDetails                    % flag whether to write details to this object in the objective functions
  end
  methods
    function h = Evaluator()
        h.lastVelocity          = 0.0;
        h.startVelocity         = 0.0;
        h.velocities            = [];
        h.curvatures            = [];
        h.time                  = 0;
        h.splineParams          = [];
        h.norm                  = 1;
        h.objectiveMultiplier   = 1.0;
        h.params                = [];
        h.optimRange            = 0;
        h.nSubdivisions         = 11;
        h.writeDetails          = false;
    end
    function evaluator = copy(h)
        evaluator   = Evaluator();
        fieldNames  = fieldnames(h);
        for k=1:length(fieldNames)
            evaluator.(fieldNames{k}) = h.(fieldNames{k});
        end
    end
    function reset(h)
        h.lastVelocity  = h.startVelocity;
        h.velocities    = h.startVelocity;
        h.curvatures    = [];
        h.time          = 0;
    end
    function appendTime(h, t)
        h.time = [h.time; h.time(end)+t];
    end
  end
end