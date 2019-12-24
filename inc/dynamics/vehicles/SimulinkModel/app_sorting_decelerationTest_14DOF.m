function app_sorting_decelerationTest_14DOF(mu)
%% Introduction
% This function reads in the simulink model data obtained from deceleration
% test for the Simulink 14DOF vehicle model and processes it to ...
% store in .csv files to be used in look up table for optimization. This
% function is used in the Path optimization app.
% Before running this function the vehicle data must be generated from the
% Simulink model
%% Input and output
% Input : friction coefficient (static) between tire and road (the option
% will be selected in th app. At the moment there are only three possible
% options (0.7, 1 and 1.5)
% Output : Function does not return anything but overwrites the
% decelerationTable.csv

%% Funcion
% first run -- > 'StraightlinePathForDeceDynamics.m' and then
% controllerReference_accelerationTest.slx (which outputs the result in
% deceResults.mat)

%% Load the file generated from simulink model based on 'mu' input

    if mu == 0.7
            load('decelerationResults_mu0p7.mat');
        elseif mu == 1
            load('decelerationResults_mu1.mat');
        elseif mu == 1.5
            load('decelerationResults_mu1p5.mat');
        else 
            error('No results for the input friction coefficient')
    end


    %%Read the vehicle data
    vel=deceResults.VehFdbk.Body.Xdot.Data;
    dece=9.81.*(deceResults.VehFdbk.Body.ax.Data);
    time=deceResults.VehFdbk.Body.ax.Time;

    %% Plot the total data acceleration and decelerations
    % figure(1);
    % plot(vel(:,1),dece(:,1));
    % xlabel("Velocity in m/s")
    % ylabel("Acceleration in m/s^2")


    %%Exclude the acceleration data
    [Max,I]=max(vel);

    dece=dece(I:end);
    vel=vel(I:end);

%     figure(2);
%     clf;
%     plot(vel,dece);
%     xlabel("Velocity in m/s")
%     ylabel("Acceleration in m/s^2")
%     hold on;


    abs_diff=abs(diff(dece)./diff(vel));

    % [ref_diff,TF]=rmoutliers(abs_diff);%,'percentile',[5 90]);

    [ref_diff,TF]=rmoutliers(dece,'percentile',[0 95]);

    indices=find(TF==0);
    dece=dece(indices);
    vel=vel(indices);

    velRefined=vel;
    deceRefined=dece;
%% Gear shifts
    diff_refined=abs(diff(deceRefined));
    mean_diff=mean(diff_refined);
    shiftIndices=find(diff_refined> mean_diff);

    %%dividing and sampling indices between shifts indices
    n=50;   %number of points in each range
    finalIndices=zeros(1,n+1);
    sizeSI=size(shiftIndices);
    sizeSI=sizeSI(1,1);
    lastIndex=size(velRefined);
    lastIndex=lastIndex(1,1);

    for i=1:sizeSI

        if i==1

            finalIndices=round(linspace(shiftIndices(i),shiftIndices(i+1),n));

        elseif i<sizeSI

            temp=round(linspace(shiftIndices(i),shiftIndices(i+1),n));
            finalIndices=[finalIndices temp];
        else
            last=round(linspace(shiftIndices(i),lastIndex,n));
            finalIndices=[finalIndices last];
            break


        end

    end

    finalIndices=unique(finalIndices);
    deceFinal=deceRefined(finalIndices);
    deceFinal(end)=0;
    velFinal=velRefined(finalIndices);
    velFinal(end)=0;


    %%Arrange the data in ascending order for interpolation table
    [velFinal_r, indices_r] = sortrows(velFinal);
    deceFinal_r=deceFinal(indices_r);

    [velFinal_r, ia,ic] = uniquetol(velFinal_r,1e-6);
    deceFinal_r = deceFinal_r(ia);

    data=[velFinal_r deceFinal_r];
    %save('deceDynamicsData.mat','data');
    % csvwrite('inc/dynamics/vehicles/SimulinkModel/decelerationTable.csv',data);
    dlmwrite('inc/dynamics/vehicles/SimulinkModel/decelerationTable.csv',data,'delimiter',',','precision',7)


%     figure(2);
%     plot(velFinal,deceFinal);


end
