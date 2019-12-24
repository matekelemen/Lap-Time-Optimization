%% Information
% This script creates the linearly placed curvature values and calls the ...
% criticalVelocitySimulink3DOF function in loop and saving the data to ... 
% corneringVelocityTable.csv

%%
%%Defining the range of the radii for evaluating velocity-curvature
%%relations

R1 = linspace(1000,300,200);
R2 = linspace(300,0.5,1800);
R=[R1 R2];
curvatures=1./R;
curvatures = curvatures';
curvatures = unique(curvatures);

mu = 1;
n=size(curvatures);
n=n(1,1);

velocities=zeros(n,1);

for i=1:n
    
    %call the function criticalVelocitySimulink3DOF, which gives the
    %critical velocity of the  3DOF model, given curvature value and
    %friction coefficient.
    
    velocities(i) = criticalVelocitySimulink3DOF(curvatures(i),mu);
end


vel_curv=[curvatures velocities];

%csvwrite('inc/dynamics/vehicles/Simulink3DOF/corneringVelocityTable.csv',vel_curv);
dlmwrite('inc/dynamics/vehicles/Simulink3DOF/corneringVelocityTable.csv',vel_curv,'delimiter',',','precision',7)


plot(curvatures(:,1),velocities(:,1));
xlabel("Curvature in 1/m")
ylabel("Cornering Velocity in m/s")