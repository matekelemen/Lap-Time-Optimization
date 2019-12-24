function GeneralVelCurv(mu,vehicleName)
   
%% Information
%Thi function is same as  velocityCurvatures.m of SimulinkModel (14DOF) and
%velocityCurvaturesSimulink3DOF.m but is called in the app and generalised
%for oth the vehicle models
%%
% This script creates the linearly placed curvature values and calls the ...
% criticalVelocitySimulink3DOF function in loop and saving the data to ... 
% corneringVelocityTable.csv

    R1 = linspace(1000,300,200);
    R2 = linspace(300,3,1800);
    R=[R1 R2];
    curvatures=1./R;
    curvatures = curvatures';
    curvatures = unique(curvatures);

    n=size(curvatures);
    n=n(1,1);

    velocities=zeros(n,1);

    for i=1:n

        velocities(i) = GeneralCorneringVel(curvatures(i),mu,vehicleName);
    end

    vel_curv=[curvatures velocities];

    pathA = 'inc/dynamics/vehicles/';
    PathB = vehicleName;
    PathC = '/corneringVelocityTable.csv';
    
    Path = [pathA,PathB,PathC];
    %csvwrite('inc/dynamics/vehicles/SimulinkModel/corneringVelocityTable.csv',vel_curv);
     dlmwrite(Path,vel_curv,'delimiter',',','precision',7)
    
%         plot(curvatures(:,1),velocities(:,1));
%         xlabel("Curvature in 1/m")
%         ylabel("Cornering Velocity in m/s")
%         legend("mu = 0.7","mu = 1","mu = 1.5")
       
%         hold on
end
