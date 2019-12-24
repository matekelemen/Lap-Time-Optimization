%% DESCRIPTION
% This script demonstrates how to set an initial solution (if unset, the
% optimization starts from the centerline).
%
% Two initial optimizations are executed first: one for minimum length, the
% other for minimum curvature. These solutions are then used as initial
% solutions for two separate lap time optimizations

%% APPEND PATH
init()

%% TRACK SETUP
clear track
track = track_DemoTrack1(0.55);

%% MODEL SETUP
evaluator                           = Evaluator();
evaluator.targetFunction            = @objective_lapTime_rateLimitedBrakeCheck;
evaluator.maxVelocityFunction       = TableLookup('SimulinkModel/corneringVelocityTable.csv','linearSearch').method;
evaluator.maxAccelerationFunction   = TableLookup('SimulinkModel/accelerationTable.csv','linearSearch').method;
evaluator.maxDecelerationFunction   = TableLookup('SimulinkModel/decelerationTable.csv','linearSearch').method;

evaluator.startVelocity             = 0;

%% RUN OPTIMIZATION
% Set subsampling and objective scaling
evaluator.nSubdivisions             = 3;
evaluator.objectiveMultiplier       = 100;

% Optimize for length and curvature first
prevaluator                         = Evaluator();
prevaluator.targetFunction          = @objective_curvature;
x0Curv  = optimizePath('evaluator',prevaluator,'track',track);

prevaluator.targetFunction          = @objective_length;
x0Len   = optimizePath('evaluator',prevaluator,'track',track);

% Optimize for lap time with different initial solutions
alpha1  = optimizePath('evaluator',evaluator,'track',track,'x0',x0Curv);
alpha2  = optimizePath('evaluator',evaluator,'track',track,'x0',x0Len);

%% POSTPROCESS
% Configure evaluator for postprocessing and to collect data
evaluator.writeDetails          = true;
evaluator.optimRange            = 0;
evaluator.norm                  = 1.0;
evaluator.objectiveMultiplier   = 1.0;
evaluator.nSubdivisions         = 20;

% Calculate lap times
tCurv   = evaluatePath(track,x0Curv,evaluator);
tLen    = evaluatePath(track,x0Len,evaluator);
t1      = evaluatePath(track,alpha1,evaluator);
t2      = evaluatePath(track,alpha2,evaluator);
disp(['Curvature optimized lap time: ',num2str(tCurv),'[s]'])
disp(['Length optimized lap time: ',num2str(tLen),'[s]'])
disp(['Lap time optimized (minimum curvature start): ',num2str(t1),'[s]'])
disp(['Lap time optimized (minimum length start): ',num2str(t2),'[s]'])

% Plot linear combinations of the curvature and length optimized paths
pathCombination(track,x0Len,x0Curv,evaluator);
%% Save results
save('doc/resultOutput/demo_initialSolution.mat',                                      ...
    'track',                                                            ...
    'evaluator',                                                        ...
    'x0Len',                                                            ...
    'x0Curv',                                                           ...
    'alpha1',                                                           ...
    'alpha2',                                                           ...
    'tLen',                                                             ...
    'tCurv',                                                            ...
    't1',                                                               ...
    't2'                                                                ...
    );