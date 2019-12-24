%% INIT

clear all
clc

% Load optimization results
load('doc/resultOutput/demo1.mat',                                      ...
                                    'track',                            ...
                                    'evaluator',                        ...
                                    'alpha'                             ...
                                                                        ...
    );

% Define path spline
pathPoints      = generatePathPoints(track.bound1, track.bound2, alpha);

offset          = [-1,3.125];
heading         = -pi/2 + 0;
pathPoints      = pathPoints - ones(length(pathPoints),1) * pathPoints(1,:);
pathPoints      = pathPoints * [cos(heading),sin(heading);              ...
                                -sin(heading),cos(heading)];
pathPoints      = pathPoints + ones(length(pathPoints),1) * offset;

[splx,sply]     = cubicSpline2D(pathPoints);

% Generate points on spline
n               = 5.0e3;
t               = linspace(0,1,n)';
pathPoints      = pointOnSpline(splx,sply,t);

% Extract necessary values from evaluator
splineParams    = t;
velocities      = interp1( evaluator.splineParams, evaluator.velocities, t );
% velocities(velocities<1.0) = 1.0;
velocities      = 5*ones(size(velocities));

curvatures      = evaluator.curvatures;


%% Plot path points
hold on
plot(pathPoints(:,2),pathPoints(:,1))
axis equal