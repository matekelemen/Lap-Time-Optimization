function [pOpt, Info] = parameterEstimation(xref,yref)
%% Description
% The function estimates the optimum vehicle parameters that will make the  
% vehicle follows the desired path. In this case, the mass, location of
% the center of gravity from the front wheels (dfront), the wheelbase and
% the height of the vehicle axle (h) are estimated.
% The function will keep in changing the parameters until the simulated 
% path will match the expected path.
%
% The function returns estimated parameter values, pOpt,
% and estimation termination information, Info.
%

%% Define the Estimation Experiments
% Initiate an experiment object to save the measured and simulated 
% positions

Exp = sdo.Experiment('MPC_Controller');

%% Specify the measured experiment output data.
% Create 2 objects (X_Position and Y_Position) to store the measured
% positions 

% Object creation
X_Position = Simulink.SimulationData.Signal;

% Specify the object name
X_Position.Name      = 'X_Position';
% Specify the block path where the simulated signals are measured from
X_Position.BlockPath = 'MPC_Controller/Longitudinal Driver,Vehicle and Environment/Selector';
% Specify the port type and index of simulated signals
X_Position.PortType  = 'outport';
X_Position.PortIndex = 1;
% Specify the measured positions
X_Position.Values    = timeseries(xref(2,:)',xref(1,:)');

% Specify the object name
Y_Position = Simulink.SimulationData.Signal;
% Specify the object name
Y_Position.Name      = 'Y_Position';
% Specify the block path where the simulated signals are measured from
Y_Position.BlockPath = 'MPC_Controller/Longitudinal Driver,Vehicle and Environment/Selector1';
% Specify the port type and index of simulated signals
Y_Position.PortType  = 'outport';
Y_Position.PortIndex = 1;
% Specify the measured positions
Y_Position.Values    = timeseries(yref(2,:)',yref(1,:)');
% Add the measured positions to the experiment as the expected output data.
Exp.OutputData = [X_Position; Y_Position];

%%
% Specify experiment parameters.
Param = sdo.getParameterFromModel('MPC_Controller',{'dfront','h','mass','wheelbase'});
% Specify the parameters limits
Param(1).Minimum = 1;
Param(1).Maximum = 1.5;
Param(2).Minimum = 0.135;
Param(2).Maximum = 0.36;
Param(2).Scale = 0.5;
Param(3).Minimum = 700;
Param(3).Maximum = 1700;
Param(4).Minimum = 2.5;
Param(4).Maximum = 6;
%%
% Add the parameters to the Experiment
Exp.Parameters = Param;

%%
% Create a model simulator from an experiment
Simulator = createSimulator(Exp);

%%
% Get the initial state values from the experiment.
s = getValuesToEstimate(Exp);
% Group the parameters and the initial states
p=[];
p = [p; s];
%%
% Plot the measured versus the simulated data
hold off
% Plot the X-Position simulated data
plot(X_Position.Values.Time,X_Position.Values.Data);
hold on
% Plot the X-Position measured data
plot(xref(1,:),xref(2,:),'o')
title('Simulated and Measured Responses Before Estimation');
legend('Measured X Position',  'Simulated X Position');
axis tight
% Plot the Y-Position simulated data
figure()
plot(Y_Position.Values.Time,Y_Position.Values.Data);
hold on
% Plot the Y-Position measured data
plot(yref(1,:),yref(2,:),'o')
title('Simulated and Measured Responses Before Estimation');
legend('Measured Y Position',  'Simulated Y Position');
axis tight
%% Create Estimation Objective Function
%
% Create a function to evaluate how closely the simulated output match the 
% measured output using the estimated parameters. This function is called
% at each optimization iteration to compute the estimation cost.
%
% Use an anonymous function with one argument that calls MPC_Controller_optFcn.
optimfcn = @(P) MPC_Controller_optFcn(P,Simulator,Exp);

%% Optimization Options
%
% Specify optimization options (Optimization Method and model).
Options = sdo.OptimizeOptions;
Options.Method = 'lsqnonlin';
Options.OptimizedModel = Simulator;

%% Estimate the Parameters
%
% Call sdo.optimize with the estimation objective function handle,
% parameters to estimate, and options.
[pOpt,Info] = sdo.optimize(optimfcn,p,Options);

%%
% Update the experiments with the new estimated parameter values.
Exp = setEstimatedValues(Exp,pOpt);

%% Update Model
%
% Update the model with the optimized parameter values.
sdo.setValueInModel('MPC_Controller',pOpt(1:0));
end

function Vals = MPC_Controller_optFcn(P,Simulator,Exp)
%% Description
%
% Function called at each iteration of the estimation problem.
%
% The function is called with a set of parameter values, P, and returns
% the estimation cost, Vals, to the optimization solver.
%

%%
% Define a signal tracking requirement to compute how well the model
% output matches the experiment data.
r = sdo.requirements.SignalTracking(...
    'Method', 'Residuals');
%%
% Update the experiment(s) with the estimated parameter values.
Exp = setEstimatedValues(Exp,P);

%%
% Simulate the model and compare model outputs with measured experiment
% data.

F_r = [];
Simulator = createSimulator(Exp,Simulator);
strOT = mat2str(Exp.OutputData(1).Values.Time);
Simulator = sim(Simulator, 'OutputOption', 'AdditionalOutputTimes', 'OutputTimes', strOT);

SimLog = find(Simulator.LoggedData,get_param('MPC_Controller','SignalLoggingName'));
for ctSig=1:numel(Exp.OutputData)
    Sig = find(SimLog,Exp.OutputData(ctSig).Name);
    
    Error = evalRequirement(r,Sig.Values,Exp.OutputData(ctSig).Values);
    F_r = [F_r; Error(:)];
end

%% Return Values.
%
% Return the evaluated estimation cost in a structure to the
% optimization solver.
Vals.F = F_r;
end