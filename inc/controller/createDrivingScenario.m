%% Description
%  This function will create a driving scenario based on the optimization
%  data 
%
function [scenario, egoVehicle,waypoints]= createDrivingScenario ...
(x,y,Ts,speedProfile)

% Construct a drivingScenario object.
scenario = drivingScenario('SampleTime',Ts);

% Construct the path
waypoints = [x,y];
waypoints(:,3) = 0;

% Specify the lanes
laneSpecification = lanespec(1, 'Width', 2.5);

% Construct the road
road(scenario, waypoints, 'Lanes', laneSpecification);

% Add the ego vehicle
egoVehicle = vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', [waypoints(1,1) waypoints(1,2) waypoints(1,3)]);

% Specify the vehicle dimensions
egoVehicle.Width = 2;

% Construct the trajectory
trajectory(egoVehicle, waypoints, speedProfile);
end