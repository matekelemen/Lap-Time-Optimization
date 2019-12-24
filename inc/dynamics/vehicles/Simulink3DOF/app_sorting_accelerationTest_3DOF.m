function app_sorting_accelerationTest_3DOF(mu)
%% Introduction
% This function reads in the simulink model data obtained from wide open...
% throttle test for the Simulink 3DOF vehicle model and processes it to ...
% store in .csv files to be used in look up table for optimization. This
% function is used in the Path optimization app.
% Before running this function the vehicle data must be generated from the
% Simulink model
%% Input and output
% Input : friction coefficient (static) between tire and road.
% Output : Function does not return anything but overwrites the
% accelerationTable.csv
%% Funcion
% first run -- > 'ControllerScript_accTest.m' and then
% MPC_Controller_accTest.m in the cotroller_update_Test

%%Load the file generated from simulink model based on 'mu' input


if mu == 0.7
    load('fullThrottleResults3DOF_mu0p7.mat');
elseif mu == 1
    load('fullThrottleResults3DOF_mu1.mat');
elseif mu == 1.5
    load('fullThrottleResults3DOF_mu1p5.mat');
else 
    error('No results for the input friction coefficient')
end

%%Read the acceleration and velocity data fom the simulink generated file
vel=results.InertFrm.Cg.Vel.Xdot.Data;
T=results.InertFrm.Cg.Vel.Xdot.Time;

%% Plot the data before filtering
% figure(1)
% plot(T,vel)
% ylabel("Velocity in m/s")
% xlabel("Time in s")
% hold on
%% Obtaining acceleration 
% As 3DOF model does not output the acceleration we have to use velocities
% and time to get acceleration.

[maxVel, i]= max(vel);

vel=vel(1:i);
T = T(1:i);

%%FInding accelerations
acc = diff(vel)./diff(T);
vel = vel(1:end-1);

%%Plot data before processing
% figure(2)
% plot(vel,acc);
% xlabel("Velocity in m/s")
% ylabel("Acceleration in m/s^2")
% hold on


%% Smooth function to remove sudden changes
acc=smooth(acc,5,'sgolay',2);

%% Remove outliers
% abs_diff=abs(diff(acc)./diff(vel));
% The percentile interval has to be varied based on trial and error until
% we get best fit curve
[ref_abs_diff,TF]=rmoutliers(acc,'percentile',[7 95]);

indices=find(TF==0);

velFinal=vel(indices);
accFinal=acc(indices);

%% Gear shifts (Identifiy the gear shifts where there is sudden chnge in acceleration
diffAcc=abs(diff(accFinal));
meanDiffAcc=mean(diffAcc);
gearShiftIndices=find(diffAcc);


%%dividing and sampling indices between gear shifts
n=5;   %number of points in each range
finalIndices=zeros(1,n+1);
sizeGSI=size(gearShiftIndices);
sizeGSI=sizeGSI(1,1);
lastIndex=size(velFinal);
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
accFinal=accFinal(finalIndices);
velFinal=velFinal(finalIndices);

[velFinal, ia,ic] = uniquetol(velFinal,1e-6);
accFinal = accFinal(ia);


velFinal(1) = 0;
accFinal(end)=0;


%% Output the data
data=[velFinal accFinal];

% csvwrite('inc/dynamics/vehicles/SimulinkModel/accelerationTable.csv',data);
dlmwrite('inc/dynamics/vehicles/Simulink3DOF/accelerationTable.csv',data,'delimiter',',','precision',7)

% figure(2)
% plot(velFinal,accFinal)
%legend("Data before","Data after")

end


