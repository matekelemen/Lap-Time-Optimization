%% DESCRIPTION
% This script creates a driving scenario based on the optimization results. 
% The scenario will be fed to a simulink model to force a 3 DOF vehile to
% follow the optimum path. The result will be simulated in XY plotter and
% Unreal Engine. Finally, the optimum vehicle parameters are estimated.
%% Inputs
    % 1. Sampling time
        Ts=0.1;
    % 2. Load Vehicle Parameter File
        load('VEH.mat')
    % 3. Vehicle mass
        mass = 1575;
    % 4. Wheelbase
        wheelbase = 2.8;
    % 5. Center of gravity location from the front wheels 
        dfront = 1.2;
    % 6. Center of gravity location from the rear wheels 
        drear=wheelbase-dfront;
    % 7. Height of the vehicle axle
        h = 0.35;
    % 8. Name of the mat file that contains the optimization info
    %     FileName='demo1';
        
%% Extract the data (path coordinates and speed profile)from the mat file
x = linspace(0,8000,100);
x=x';
sz=size(x);
sz=sz(1,1);
y = zeros(sz,1);

speedProfile = 50*ones(sz,1);
speedProfile(end) = 0;

% [x,y,speedProfile] = extractTheData(FileName);

%% Driving Senario Creation
[scenario, egoVehicle,waypoints]= createDrivingScenario(x,y,Ts,speedProfile);

%% Reference Path Creation
[refPoses, x0, y0, theta0, simStopTime,speedVector,curvatures]=  ...
helperCreateReferencePath(scenario);

%% Additional variables needed for the simulation
% Find the velocity magnitude
%speedVector(235:end)= speedVector(235:end)/2; 
 speedProfile  = sqrt(sum(speedVector.*speedVector,2));
% Specify the motion direction (1 is forward motion and -1 is reverse motion)
directions=ones(size(speedProfile));

%% Buses Creation
% Create the bus of actors from the Simulink Model
modelName = 'MPC_Controller_deceTest';
wasModelLoaded = bdIsLoaded(modelName);
if ~wasModelLoaded
    load_system(modelName)
end
% Create buses for lane sensor and lane sensor boundaries
helperCreateLaneSensorBuses;

%% Open the Simulink model and start the simulation
open_system (modelName)
sim(modelName);

%% Load the Reference positions
% The positions are saved in a mat file during the simulation. These values
% are used in the parameters estimation
load('xref.mat');
load('yref.mat');
