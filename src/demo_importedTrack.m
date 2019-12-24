init()
%% TRACK SETUP
clear track
track = track_DemoTrack1(0.08);

%% MODEL SETUP
evaluator                           = Evaluator();
evaluator.targetFunction            = @objective_lapTime_rateLimitedBrakeCheck;
evaluator.maxVelocityFunction       = TableLookup('inc/dynamics/vehicles/SimulinkModel/corneringVelocityTable.csv', 'linearSearch').method;
evaluator.maxAccelerationFunction   = TableLookup('inc/dynamics/vehicles/SimulinkModel/accelerationTable.csv', 'linearSearch').method;
evaluator.maxDecelerationFunction   = TableLookup('inc/dynamics/vehicles/SimulinkModel/decelerationTable.csv', 'linearSearch').method;
evaluator.startVelocity             = 0;

%% SET GLOBAL AND LOCAL EVALUATORS
% Global optimization settings
evaluatorGlob                       = evaluator.copy();
evaluatorGlob.nSubdivisions         = 4;
% Local optimization settings
evaluatorLoc                        = evaluator.copy();
evaluatorLoc.nSubdivisions          = 3;
refinement                          = 1.8;

%% RUN OPTIMIZATION
errorLog = { };

% Optimize
try
    [alpha,track,timing]  = optimizePathIterative(                          ...
        evaluatorGlob,                                                      ...
        evaluatorLoc,                                                       ...
        refinement,                                                         ...
        'x0',zeros(length(track.bound1),1),                                 ...
        'track',track);
catch exception
    errorLog(end+1) = {exception};
end

%% POSTPROCESS
try
    % Calculate lap time
    evaluatorLoc.writeDetails   = true;
    evaluatorLoc.norm           = 1.0;
    evaluatorLoc.optimRange     = 0;
    tLap            = evaluatePath(track,evaluatorLoc.params,evaluatorLoc);
    % Plot
    close all
    plotSolution(track,evaluatorLoc.params,evaluatorLoc);
catch exception
    errorLog(end+1) = {exception};
end

%% Save results
save('doc/resultOutput/demo_importedTrack.mat');

%% SEND RESULTS
mail = 'sendermatlab@gmail.com';
target  = 'kelemen.mate.12@gmail.com';
fileID  = fopen('C:\Users\LapTime\Desktop\matlabopts.bin');

setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',cast(fread(fileID)','char'));

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

sendmail(                                                               ...
    target,                                                             ...
    'MATLAB execution terminated',                                      ...
    ['MATLAB finished running ',mfilename],                             ...
    'doc/resultOutput/demo_importedTrack.mat'                           ...
    );

fclose(fileID);