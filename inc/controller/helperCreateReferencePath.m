%% Description
% This function will create a fine reference path and a cooresponding
% velocity vector based on the driving scenario created and the sampling
% time
% Copyright 2018-2019 The MathWorks, Inc.

function [refPoses, x0, y0, theta0,simStopTime,speed, curvatures,simTime] = ...
helperCreateReferencePath(scenario)

% Create empty arrays to store the reference position, speed, simulation 
% time and path curvature
refPoses   = [];
speed   = [];
simTime =[];
curvatures = [];
% Extract ego pose information by advancing the simulation one time step
% at a time.

restart(scenario);
while advance(scenario)
    egoVehicle = scenario.Actors(1);
    refPoses   = [refPoses; [egoVehicle.Position(1:2), egoVehicle.Yaw]];
    simTime    = [simTime; scenario.SimulationTime];
    speed= [speed; [egoVehicle.Velocity]];
    lb         = laneBoundaries(egoVehicle);
    curvatures = [curvatures; mean([lb.Curvature])];

end

% Set initial positon and speed and the total time
x0     = refPoses(1, 1);
y0     = refPoses(1, 2);
theta0 = refPoses(1, 3);
simStopTime = simTime(end);

end