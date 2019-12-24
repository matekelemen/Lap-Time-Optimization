
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
        mass = 2500;
    % 4. Wheelbase
        wheelbase = 2.8;
    % 5. Center of gravity location from the front wheels 
        dfront = 1.2;
    % 6. Center of gravity location from the rear wheels 
        drear=wheelbase-dfront;
    % 7. Height of the vehicle axle
        h = 0.35;
    % 8. Front tire Corner Stiffness
        f_tire_stiff= 40000;
    % 9. Front tire Corner Stiffness
        r_tire_stiff= 40000;
    % 10. Coefficient of Friction
        mu = 1;
    % 11. Steering Agressiveness 
        aggressive= 0.2;
    % 12. Max steering angle in rad
        max_steer= 0.19;
    % 13. Min steering angle in rad
        min_steer= -0.19;
    % 14. Controller Prediction Horizon
        pred_Horizon= 10;
    % 15. Name of the mat file that contains the optimization info
        FileName='AppOutput';

%% Extract the data (path coordinates and speed profile)from the mat file
[x,y,speedProfile] = extractTheData(FileName);

%% Driving Senario Ceation
[scenario, egoVehicle,waypoints]= createDrivingScenario(x,y,Ts,speedProfile);

%% Reference Path Creation
[refPoses, x0, y0, theta0, simStopTime,speedVector,curvatures, simTime]=  ...
helperCreateReferencePath(scenario);

%% Additional variables needed for the simulation
% Find the velocity magnitude
speedProfile  = sqrt(sum(speedVector.*speedVector,2));
% Specify the motion direction (1 is forward motion and -1 is reverse motion)
directions=ones(size(speedProfile));

%% Buses Creation
% Load the bus of actors 
load('BusActors1Actors.mat')
% Create buses for lane sensor and lane sensor boundaries
helperCreateLaneSensorBuses;

%% Open the Simulink model and start the simulation
modelName = 'MPC_Controller';
open_system (modelName)
sim(modelName);

%% Load the Reference positions
% The positions are saved in a mat file during the simulation. These values
% are used in the parameters estimation
load('xref.mat');
load('yref.mat');

%% Paramaters Estimation
% Estimate the optimum vehicle wheelbase, mass, axle height and center of 
% gravity location using Least Square Method
[pOpt, Info] = parameterEstimation(xref,yref);