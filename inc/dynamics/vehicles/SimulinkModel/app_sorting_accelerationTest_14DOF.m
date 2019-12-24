function app_sorting_accelerationTest_14DOF(mu)

%% Introduction
% This function reads in the simulink model data obtained from wide open...
% throttle test for the Simulink 14DOF vehicle model and processes it to ...
% store in .csv files to be used in look up table for optimization. This
% function is used in the Path optimization app.
% Before running this function the vehicle data must be generated from the
% Simulink model
%% Input and output
% Input : friction coefficient (static) between tire and road.
% Output : Function does not return anything but overwrites the
% accelerationTable.csv
%% Funcion
% first run -- > 'StraightlinePathForAccDynamics.m' and then
% controllerReference_accelerationTest.slx (which outputs the result in
% fullThrottleResults.mat)

%% Load the file generated from simulink model based on 'mu' input


    if mu == 0.7
        load('fullThrottleResults_mu0p7.mat');
    elseif mu == 1
        load('fullThrottleResults_mu1.mat');
    elseif mu == 1.5
        load('fullThrottleResults_mu1p5.mat');
    else 
        error('No results for the input friction coefficient')
    end
    
    %%Read the acceleration and velocity data fom the simulink generated file
    acc=9.81.*results.VehFdbk.Body.ax.Data;
    vel=results.VehFdbk.Body.Xdot.Data;

    %% Plot the data before filtering
%     plot(vel,acc)
%     xlabel("Velocity in m/s")
%     ylabel("Acceleration in m/s^2")
%     hold on

    %% Smoothing the  data using Savitzky-Golay filter
    acc=smooth(acc,20,'sgolay',2);

    %% Remove outliers
    abs_diff=abs(diff(acc)./diff(vel));
    [ref_abs_diff,TF]=rmoutliers(abs_diff,'percentile',[5 100]);

    indices=find(TF);

    velRefined=vel(indices);
    accRefined=acc(indices);


    %% gear shift indices
    diffAcc=abs(diff(accRefined));

    meanDiffAcc=mean(diffAcc);
    gearShiftIndices=find(diffAcc>2*meanDiffAcc);

    %plot(velRefined(gearShiftIndices),accRefined(gearShiftIndices))

    %%dividing and sampling indices between gear shifts
    n=5;   %number of points in each range
    finalIndices=zeros(1,n+1);
    sizeGSI=size(gearShiftIndices);
    sizeGSI=sizeGSI(1,1);
    lastIndex=size(velRefined);
    lastIndex=lastIndex(1,1);


    for i=1:sizeGSI

        if i==1

            finalIndices=round(linspace(gearShiftIndices(i),gearShiftIndices(i+1),n));

        elseif i<sizeGSI

            temp=round(linspace(gearShiftIndices(i),gearShiftIndices(i+1),n));
            finalIndices=[finalIndices temp];
        else
            last=round(linspace(gearShiftIndices(i),lastIndex,n));
            finalIndices=[finalIndices last];
            break


        end

    end
    finalIndices=unique(finalIndices);
    accFinal=accRefined(finalIndices);
    velFinal=velRefined(finalIndices);

    [velFinal, ia,ic] = uniquetol(velFinal,1e-6);
    accFinal = accFinal(ia);

    %% Output the data
    data=[velFinal accFinal];
    %save('accDynamicsData.mat','data');
    % csvwrite('inc/dynamics/vehicles/SimulinkModel/accelerationTable.csv',data);
    dlmwrite('inc/dynamics/vehicles/SimulinkModel/accelerationTable.csv',data,'delimiter',',','precision',7)


%       plot(velRefined(finalIndices),accRefined(finalIndices))
% 
%      legend("High fidelity simulated data","Look up table data")
%      axis tight

    
    
end


