%% DESCRIPTION
% This function will take the optimization file name as an input and
% extract the optimization data (Path coordinates and speed profile) 
% from that file

function [x,y,speedProfile] = extractTheData(FileName)

% Load the results of an optimization
F= ['doc/resultOutput/' FileName];
load(F,'-mat','track','evaluator','alpha');

% Combine the path parameters and the track boundaries to generate points
% on the path
pathPoints = generatePathPoints(track.bound1, track.bound2, alpha);
                    
% Create a spline that interpolates the path points          
[splineX, splineY]  = cubicSpline2D(pathPoints);

% Get spline parameters at which it was sampled in the optimization
xi                  = evaluator.splineParams;

% Get spline points at the samples (check built in function: ppval)
x                   = ppval(splineX, xi);
y                   = ppval(splineY, xi);

% Get the speed profile along the optimum path
speedProfile        = evaluator.velocities;
end