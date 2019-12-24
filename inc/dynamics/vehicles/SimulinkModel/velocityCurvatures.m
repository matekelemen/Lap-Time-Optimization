%% Information
% This script creates the linearly placed curvature values and calls the ...
% criticalVelocitySimulink3DOF function in loop and saving the data to ... 
% corneringVelocityTable.csv

%% 
%%Defining the range of the radii for evaluating velocity-curvature
%%relations

R1 = linspace(1000,300,200);
R2 = linspace(300,3,1800);
R=[R1 R2];
curvatures=1./R;
curvatures = curvatures';

n=size(curvatures);
n=n(1,1);

velocities=zeros(n,1);

for i=1:n
    %call the function criticalVelocity, which gives the
    %critical velocity of the Simulink 14DOF model,(in out case it is named "SimulinkModel"
    %input curvature value and friction coefficient.
    
    velocities(i) = criticalVelocity(curvatures(i));
end

vel_curv=[curvatures velocities];

csvwrite('inc/dynamics/vehicles/SimulinkModel/corneringVelocityTable.csv',vel_curv);