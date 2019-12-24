
%% Information
%This script does the same function as app_sorting_acceleration_14DOF.m
%function but it can be run independentely and see the out put results


%% %% Load already available 'fullThrottleresults_mu**.mat'
% OR
%  first run -- > 'StraightlinePathForAccDynamics.m' and then
% controllerReference_accelerationTest.slx (which outputs the result in
% fullThrottleResults.mat)
%% Examples of generated files are 
%%fullThrottleResults_m0p7.mat --> for coefficient friction = 0.7
%%fullThrottleResults_mu1.mat --> for coefficient friction = 1
%%fullThrottleResults_mu1p7.mat --> for coefficient friction = 1.5

%% Function

load('fullThrottleResults_mu1.mat');

 %%Read the acceleration and velocity data fom the simulink generated file
    acc=9.81.*results.VehFdbk.Body.ax.Data;
    vel=results.VehFdbk.Body.Xdot.Data;

    %% Plot the data before filtering
    plot(vel,acc)
    xlabel("Velocity in m/s")
    ylabel("Acceleration in m/s^2")
    hold on

    %% Smoothing the  data using Savitzky-Golay filter
    acc=smooth(acc,20,'sgolay',2);

    %% Remove outliers
    abs_diff=abs(diff(acc)./diff(vel));
    [ref_abs_diff,TF]=rmoutliers(abs_diff,'percentile',[5 100]);

    indices=find(TF);

    %plot(vel(indices),acc(indices))

    velRefined=vel(indices);
    accRefined=acc(indices);


    %% Gear shift indices
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

%%If you want to overwrite the .csv file,which will be used for optimization, then
%%uncomment the following

% csvwrite('inc/dynamics/vehicles/SimulinkModel/accelerationTable.csv',data);

% figure(1)
%  plot (vel,acc)
% grid;


%% Plot processed data
 plot(velRefined(finalIndices),accRefined(finalIndices))
 %legend("Data before","Data after")
 %axis tight
%  legend("mu = 0.7","mu = 1","mu = 1.5")
%  xlabel("Velocity in m/s")
%  ylabel("Acceleration in m/s^2")
%  hold on
