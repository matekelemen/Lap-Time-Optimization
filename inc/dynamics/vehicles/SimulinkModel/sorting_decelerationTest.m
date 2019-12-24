%% Information
%This script does the same function as app_sorting_deceleration_3DOF.m
%function but it can be run independentely and see the out put results


%% %% Load already available 'deceResults_mu**.mat'
% OR
%  first run -- > 'StraightlinePathForDeceDynamics.m' and then
% controllerReference_decelerationTest.slx (which outputs the result in
% deceResults.mat)
%% Examples of generated files are 
% deceResults_mu0p7.mat --> for coefficient friction = 0.7
% deceResults_mu1.mat --> for coefficient friction = 1
% deceResults_mu1p7.mat --> for coefficient friction = 1.5
%%


%%Read the vehicle data
load('decelerationResults_mu1.mat');

vel=deceResults.VehFdbk.Body.Xdot.Data;
dece=9.81.*deceResults.VehFdbk.Body.ax.Data;
time=deceResults.VehFdbk.Body.ax.Time;


[Max,I]=max(vel);

dece=dece(I:end);
vel=vel(I:end);
dece_mps2=dece;


data_um = dece_mps2;
%% Plot the data before processing
plot(vel,dece_mps2);
xlabel("Velocity in m/s")
ylabel("Acceleration in m/s^2")
hold on;

%%
%abs_diff=abs(diff(dece)./diff(vel));

% [ref_diff,TF]=rmoutliers(abs_diff);%,'percentile',[5 90]);

%% Remove outliers
[ref_diff,TF]=rmoutliers(dece,'percentile',[0 95]);

indices=find(TF==0);
dece=dece(indices);
vel=vel(indices);



% plot(vel,dece)

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

data=[velFinal deceFinal];
%save('deceDynamicsData.mat','data');
% csvwrite('inc/dynamics/vehicles/SimulinkModel/decelerationTable.csv',data);


%% Plot data after processing
plot(velFinal,deceFinal)
legend("High Fidelity simulated data","Lookup table data")
% legend("mu = 0.7","mu = 1","mu = 1.5")
 xlabel("Velocity in m/s")
 ylabel("Acceleration in m/s^2")
 hold on