%% DESCRIPTION
% This script demonstrates how to run an optimization subdivided into 
% sections. First, a global optimization is carried out on a coarse mesh,
% then each section is optimized sequentially with an increased number of
% parameters.
%
% This script is only meant to demonstrate how sectionwise optimization is
% carried out, and only minimizes curvature (in order to execute faster).
%
% This feature is not finished completely and needs some further
% improvement/debugging. In order to ensure the optimization is executed
% without terminating on errors, try statements are implemented in
% optimizePathIterative, meaning that it might not yield any usable results
% if an error occurs during execution. Note: the function creates an
% intermediate log that is stored in doc/resultOutput/log.

%% APPEND PATH
init()

%% TRACK SETUP
track   = track_LBend(0.75);

%% EVALUATOR SETUP
% Create Evaluator instanes for global and sectionwise optimization, and
% set the objective
evaluatorGlobal                 = Evaluator();
evaluatorGlobal.targetFunction  = @objective_curvature;
evaluatorLocal                  = evaluatorGlobal.copy();

% Set subsampling
evaluatorGlobal.nSubdivisions   = 2;
evaluatorGlobal.nSubdivisions   = 3;

% Set refinement for sectionwise optimization, the number of parameters in
% each section will be multiplied by this coefficient
refinement                      = 1.5;

%% RUN OPTIMIZATION
[params,track]              = optimizePathIterative(                    ...
                                evaluatorGlobal,                        ...
                                evaluatorLocal,                         ...
                                refinement,                             ...
                                'track',track);

%% POSTPROCESSING
% Postprocessing only makes sense if velocities were calculated during the
% evaluation of the objective. Since this script minimizes the curvature,
% this step is not necessary. Nevertheless it is kept here to demonstrate
% how it can be set up.

% Configure Evaluator to collect data
% evaluatorLocal.optimRange    = 0;
% evaluatorLocal.writeDetails  = true;
% evaluatorLocal.norm          = 1.0;
% 
% Collect data
% evaluatePath(track,evaluatorLocal.params,evaluatorLocal);
% 
% Plot results
% plotSolution(track,evaluatorLocal.params,evaluatorLocal);

%% SAVE OPTIMIZATION DATA
alpha   = evaluatorLocal.params;

save('doc/resultOutput/demo_sectioning.mat',                            ...
    'track',                                                            ...
    'evaluatorLocal',                                                   ...
    'alpha',                                                            ...
    'refinement');