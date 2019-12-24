function controller_call(mass,wheelbase,COG,h,ftire,rtire,mu,agg,maxsteer,minsteer,pred)

%% DESCRIPTION
% This script is a modified version of "ControllerScript" for the app.
% In this script, evalin is used to save the function variables in the base
% workspace. It creates a driving scenario based on the optimization results. 
% The scenario will be fed to a simulink model to force a 3 DOF vehile to
% follow the optimum path. 
%% Inputs
    % 0. Save the vehicle parameters into the base workspace
        save('inc\controller\controller_log\ws');
        evalin('base','load("inc\controller\controller_log\ws");');
    % 1. Sampling time
        evalin('base','Ts=0.1;');
    % 2. Load Vehicle Parameter File
        evalin('base',"load('VEH.mat');")
    % 3. Name of the mat file that contains the optimization info
        evalin('base',"FileName='AppOutput';");
    % 4. Vehicle Mass
        evalin('base',"mass=mass;");
    % 5. Wheelbase
        evalin('base','wheelbase=wheelbase;');
    % 6. Center of gravity location from the front wheels 
        evalin('base','dfront=COG;');
    % 7. Center of gravity location from the rear wheels 
        evalin('base','drear=wheelbase-dfront;');
    % 8. Height of the vehicle axle
        evalin('base','h=h;');
    % 9. Front tire Corner Stiffness
        evalin('base','f_tire_stiff= ftire');
    % 10. Front tire Corner Stiffness
        evalin('base','r_tire_stiff= rtire');
    % 11. Coefficient of Friction
        evalin('base','mu=mu');
    % 12. Steering Agressiveness 
        evalin('base','aggressive= agg');
    % 13. Max steering angle in rad
        evalin('base','max_steer= maxsteer');
    % 14. Min steering angle in rad
        evalin('base','min_steer= minsteer');
    % 15. Controller Prediction Horizon
        evalin('base','pred_Horizon= pred');
        
%% Extract the data (path coordinates and speed profile)from the mat file
evalin('base',"[x,y,speedProfile] = extractTheData(FileName);");

%% Driving Senario Creation
evalin('base','[scenario, egoVehicle,waypoints]= createDrivingScenario(x,y,Ts,speedProfile);');

%% Reference Path Creation
evalin('base','[refPoses, x0, y0, theta0, simStopTime,speedVector,curvatures]=helperCreateReferencePath(scenario);');

%% Additional variables needed for the simulation
% Find the velocity magnitude
evalin('base','speedProfile  = sqrt(sum(speedVector.*speedVector,2));');
% Specify the motion direction (1 is forward motion and -1 is reverse motion)
evalin('base','directions=ones(size(speedProfile))');

%% Buses Creation
% Load the bus of actors
evalin('base',"load('BusActors1Actors')");
% Create buses for lane sensor and lane sensor boundaries
evalin('base','helperCreateLaneSensorBuses');
%% Open the Simulink model and start the simulation
modelName = 'MPC_Controller';
open_system (modelName);
end