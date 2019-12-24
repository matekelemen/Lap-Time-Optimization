%% Information
%This script does the same function as app_sorting_deceleration_3DOF.m
%function but it can be run independentely and see the out put results


%% 
% Load already available 'deceResults3DOF_mu**.mat'
% OR
% first run -- > 'ControllerScript_deceTest.m' and then,
% MPC_Controller_deceTest.slx in the folder cotroller_update_Test to obtain
% the 'deceResults3DOF_mu**.mat' files.

%%Read the vehicle data
load('deceResults3DOF_mu1.mat');

vel=results.InertFrm.Cg.Vel.Xdot.Data;
T=results.InertFrm.Cg.Vel.Xdot.Time;

%% Plot the total data acceleration and decelerations
% figure(1);
% plot(T,vel);
% ylabel("Velocity in m/s")
% xlabel("Time in s")


%% Exclude the acceleration data
A = diff(vel);
I = find(A < 0);
vel = vel(I);
T = T(I);

% figure(2);
% plot(T,vel);
% xlabel("Velocity in m/s")
% ylabel("Acceleration in m/s^2")
% hold on;

%% Find Decelerations

dece = diff(vel)./diff(T);
vel = vel(1:end-1);

figure(3);
plot(vel,dece);
xlabel("Velocity in m/s")
ylabel("Acceleration in m/s^2")
hold on;

%% Smoothen the data to avoid sharp peaks
dece=smooth(dece,3,'sgolay',2);

%% Remove outliers
abs_diff=abs(diff(dece)./diff(vel));

%%The percentile values have to be conrolled manually until we get satisfactory results
[ref_diff,TF]=rmoutliers(abs_diff,'percentile',[7 95]); 

%[ref_diff,TF]=rmoutliers(dece,'percentile',[5 90]);

indices=find(TF);
dece=dece(indices);
vel=vel(indices);

velRefined=vel;
deceRefined=dece;

diff_refined=abs(diff(deceRefined));
mean_diff=mean(diff_refined);
shiftIndices=find(diff_refined>mean_diff);

%% Dividing and sampling indices between shifts indices
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

velFinal=velRefined(finalIndices);



%%Arrange the data in ascending order for interpolation table
[velFinal_r, indices_r] = sortrows(velFinal);
deceFinal_r=deceFinal(indices_r);

%%Get unique values with respect to data sites  
[velFinal_r, ia,ic] = uniquetol(velFinal_r,1e-6);
deceFinal_r = deceFinal_r(ia);
deceFInal_r(1) = 0;
velFinal_r(1) = 0;
deceFinal_r(end)=0;

%%  Output the data
data=[velFinal_r deceFinal_r];

% If you want to overwrite the decelerationTable.csv which i used for optmization,uncomment the below command.
%dlmwrite('inc/dynamics/vehicles/Simulink3DOF/decelerationTable.csv',data,'delimiter',',','precision',7)

%% Plot the data after processing
figure(3);
plot(velFinal,deceFinal);
legend("Data before","Data after")
