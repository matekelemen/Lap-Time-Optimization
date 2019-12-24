%% DESCRIPTION
% This demo covers the output of the optimization and the method of
% reconstructing the path and the calculated variables along the optimized
% path.
%
% The optimization algorithm returns the parameters by which the path is
% defined within a track. As a side effect, it also modifies the evaluator
% structure, which contains the parameters at which the path was sampled
% and the corresponding curvature/path length/velocity/elapsed time values
% (depending on the objective function).
%% PATH SPLINE
% Load the results of an optimization
init()
load('doc/resultOutput/demo1.mat');

% Combine the path parameters and the track boundaries to generate points
% on the path
pathPoints = generatePathPoints(track.bound1, track.bound2, alpha);

% Create a spline that interpolates the path points
[splineX, splineY] = cubicSpline2D(pathPoints);

%% PATH POINTS, CURVATURES, AND LENGTHS
% Get spline parameters at which it was sampled in the optimization
xi      = evaluator.splineParams;

% Get spline points at the samples (check built in function: ppval)
x       = ppval(splineX, xi);
y       = ppval(splineY, xi);

% Get curvature at the samples
curv    = curvature(splineX, splineY, xi);

% Get spline length at the samples (measured from the starting point)
L       = arcLength(splineX, splineY, xi);

%% TANGENTS AND NORMALS
% Compute spline derivative (check built-in function: fnder)
dSplineX    = fnder(splineX,1);
dSplineY    = fnder(splineY,1);

% Sample derivatives at the sample points
dx          = ppval(dSplineX,xi);
dy          = ppval(dSplineY,xi);

% Tangent of path == derivative of the spline
tangents    = [dx,dy];

% Normalize tangents
tangents    = tangents./( vecnorm(tangents')'*[1,1] );

% Calculate normals (perpendicular to the tangent)
normals     = [-tangents(:,2), tangents(:,1)];

%% VELOCITY VECTOR
% Get velocities at sample points from the evaluator
% These are velocity magnitudes (along the path)
velocities  = evaluator.velocities;

% Get velocity vectors (assuming the vehicle always follows the path,
% which means its velocity is always tangent to the path)
velocities  = (velocities*[1,1]) .* tangents;

%% ACCELERATION VECTOR
% Get elapsed times at sample points
t               = evaluator.time;

% Simplest acceleration approximation: a~dv/dt
accelerations   = diff(velocities) ./ (diff(t)*[1,1]);