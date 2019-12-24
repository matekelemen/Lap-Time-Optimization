function [pOpt, Info] = parameterEstimation_app(mass_check,wheelbase_check,cog_check,h_check,                   ...
                        f_tire_check,r_tire_check,mu_check,agr_check,min_check,max_check,pred_check,            ...
                        mass,wheelbase,COG,h,f_tire, r_tire, mu,agre, maxi,mini, pred,                           ...
                        mass_min,mass_max,wheelbase_min,wheelbase_max,COG_min,COG_max,h_min,h_max,              ...
                        f_tire_max,f_tire_min, r_tire_max,r_tire_min, mu_max,mu_min,agre_max,agre_min,          ...
                        mini_max,mini_min,maxi_max, maxi_min, pred_max,pred_min)    
%% Description
% This function is a modified version of 'parameterEstimation' for the app
% It estimates the parameter(s) depending on the user choice. 
%% Load the Reference positions
% The positions are saved in a mat file during the simulation. These values
% are used in the parameters estimation
load('xref.mat');
load('yref.mat');

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
% Check which parameter(s) are chosen by the user
F={cog_check h_check mass_check wheelbase_check, f_tire_check, ...
    r_tire_check,mu_check,agr_check,min_check,max_check,pred_check};
parameters=F(~cellfun('isempty',F));
% Specify experiment parameters.
Param = sdo.getParameterFromModel('MPC_Controller',parameters);
% Specify the parameters limits
i=1;
    if ismember('dfront',F)
        Param(i).Value= COG;
        Param(i).Minimum = COG_min;
        Param(i).Maximum = COG_max;
        i=i+1;
    end
    if ismember('h',F)
        Param(i).Value= h;        
        Param(i).Minimum = h_min;
        Param(i).Maximum = h_max;
        Param(i).Scale = 0.5;
        i=i+1;
    end
    if ismember('mass',F)
        Param(i).Value= mass;
        Param(i).Minimum = mass_min;
        Param(i).Maximum = mass_max;    
        i=i+1;
    end
    if ismember('wheelbase',F)
        Param(i).Value= wheelbase;        
        Param(i).Minimum = wheelbase_min;
        Param(i).Maximum = wheelbase_max;
        i=i+1;
    end
    if ismember('f_tire_stiff',F)
        Param(i).Value= f_tire;        
        Param(i).Minimum = f_tire_min;
        Param(i).Maximum = f_tire_max;
        i=i+1;
    end
    if ismember('r_tire_stiff',F)
        Param(i).Value= r_tire;        
        Param(i).Minimum = r_tire_min;
        Param(i).Maximum = r_tire_max;
        i=i+1;
    end    
    if ismember('mu',F)
        Param(i).Value= mu;        
        Param(i).Minimum = mu_min;
        Param(i).Maximum =mu_max;
        i=i+1;
    end  
    if ismember('aggressive',F)
        Param(i).Value= agre;        
        Param(i).Minimum = agre_min;
        Param(i).Maximum = agre_max;
        i=i+1;
    end  
    if ismember('min_steer',F)
        Param(i).Value= mini;        
        Param(i).Minimum = mini_min;
        Param(i).Maximum = mini_max;
        i=i+1;
    end  
    if ismember('max_steer',F)
        Param(i).Value= maxi;        
        Param(i).Minimum = maxi_min;
        Param(i).Maximum = maxi_max;
        i=i+1;
    end      
    if ismember('pred_Horizon',F)
        Param(i).Value= pred;        
        Param(i).Minimum = pred_min;
        Param(i).Maximum = pred_max;
        i=i+1;
    end   

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
