%% Information
%This script does the same function as app_sorting_acceleration_3DOF.m
%function but it can be run independentely and see the out put results


%% Load already available 'fullThrottleresults3DOF_mu**.mat'
% OR
% first run -- > 'ControllerScript_accTest.m' and then,
% MPC_Controller_accTest.slx in the folder cotroller_update_Test to obtain
% the 'fullThrottleResults3DOF_mu**.mat' files.


load('fullThrottleResults3DOF_mu1.mat');

%%Read the acceleration and velocity data fom the simulink generated file
vel=results.InertFrm.Cg.Vel.Xdot.Data;
T=results.InertFrm.Cg.Vel.Xdot.Time;

%%Plot the data before filtering
figure(1)
plot(T,vel)
ylabel("Velocity in m/s")
xlabel("Time in s")
hold on

[maxVel, i]= max(vel);

vel=vel(1:i);
T = T(1:i);

%%FInding accelerations
acc = diff(vel)./diff(T);
vel = vel(1:end-1);

%% Plot data before processing
figure(2)
plot(vel,acc);
xlabel("Velocity in m/s")
ylabel("Acceleration in m/s^2")
hold on


%%  Smooth function to remove sudden changes
acc=smooth(acc,5,'sgolay',2);

%%  Remove outliers
% abs_diff=abs(diff(acc)./diff(vel));
[ref_abs_diff,TF]=rmoutliers(acc,'percentile',[7 95]);

indices=find(TF==0);

plot(vel(indices),acc(indices))

velFinal=vel(indices);
accFinal=acc(indices);

%%  Gear shifts
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


%%  Output the data
data=[velFinal accFinal];

% If you want to overwrite the accelerationTable.csv which i used for optmization,uncomment the below command.
%dlmwrite('inc/dynamics/vehicles/Simulink3DOF/accelerationTable.csv',data,'delimiter',',','precision',7)


%% Plot the data after processing
figure(2)
plot(velFinal,accFinal)

legend("Data before","Data after")


