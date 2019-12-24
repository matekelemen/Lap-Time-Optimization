%% DESCRIPTION
% This script demonstrates how to run an optimization on the lap time.
% Note: this script runs for ~4 hours; for a faster execution on a simpler
% track, consider running demo_lapTimeOptimization_quick.

%% APPEND PATH
init()

%% TRACK SETUP
% Load track and reduce the number of points (.9 the original number)
track = track_Hockenheimring(0.9);

%% MODEL SETUP
% Create an instane of the Evaluator class
evaluator                           = Evaluator();

% Set objective
evaluator.targetFunction            = @objective_lapTime_rateLimitedBrakeCheck;

% Set lookup tables (vehicle model)
evaluator.maxVelocityFunction       = TableLookup('SimulinkModel/corneringVelocityTable.csv','linearSearch').method;
evaluator.maxAccelerationFunction   = TableLookup('SimulinkModel/accelerationTable.csv','linearSearch').method;
evaluator.maxDecelerationFunction   = TableLookup('SimulinkModel/decelerationTable.csv','linearSearch').method;

% Set initial velocity
evaluator.startVelocity             = 0;

%% RUN OPTIMIZATION
% Set subsampling and objective scaling
evaluator.nSubdivisions             = 30;
evaluator.objectiveMultiplier       = 1e3;

% Run optimization
alpha  = optimizePath('evaluator',evaluator,'track',track);

%% PLOT RESULTS
% Calculate lap time
evaluator.writeDetails  = true;
evaluator.norm          = 1.0;
tLap                    = evaluatePath(track,alpha,evaluator);

% Plot track and optimized path
close all
plotSolution(track,alpha,evaluator);

%% Save results
save('doc/resultOutput/demo_lapTimeOptimization.mat',                                      ...
    'track',                                                            ...
    'evaluator',                                                        ...
    'alpha',                                                            ...
    'tLap'                                                              ...
    );