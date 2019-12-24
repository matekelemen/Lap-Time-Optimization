function vMax = GeneralCorneringVel(curvature,mu,vehicleName)
    
%% Information
% This function is same as criticalVelocity(curvture) of 14DOF model and 
% criticalVelocitySimulink3DOF(curvture) bu this function is genaralised to
% both vehicle models and to be used in the app

%% Inputs and Outputs
    % Input : Path curvatures [1/m] and static friction coefficient mu and
    %         vehicle model
    % Output : Critical velocity of cornering
%%
    pathA = 'inc/dynamics/vehicles/';
    PathC = '/vehParams.mat';
    
    PathB = vehicleName;
    
    Path = [pathA,PathB,PathC];
    
    load(Path,'VEH')
    
    g = 9.81;                                            %% gravitational acceleration m/s^2

    mVehicle = VEH.Mass;                                 %% Mass of the entire vehicle
    mFR = VEH.StaticNormalFrontLoad.FR;                  %%Load in kg on front right wheel
    mFL = VEH.StaticNormalFrontLoad.FL;                  %%Load in kg on front left wheel

    mRR = VEH.StaticNormalRearLoad.RR;                   %%Load in kg on rear right wheel
    mRL = VEH.StaticNormalRearLoad.RL;                   %%Load in kg on rear left wheel

    b = VEH.WheelBase;                                                %%Track width

    h = VEH.HeightCG;                                         %%Centre of gravity

    %mu = 1;                                            %%Static friction 

    maxVel = 50 ;                                       %%Maximum velocity achievable by the model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%Loads on wheels

    lFR = mFR*g;
    lFL = mFL*g;
    lRR = mRR*g;
    lRL = mRL*g;

    %%Friction forces
    fFR = mu*lFR;
    fFL = mu*lFL;
    fRR = mu*lRR;
    fRL = mu*lRL;


    vMax_slide = sqrt((fFR+fFL+fRR+fRL)/((curvature+0.0001)*mVehicle));

    vMax_overturn = sqrt((lFR*b/2)+(lRR*b/2)/((curvature+.0001)*mVehicle*h));

    v=[vMax_slide,vMax_overturn,maxVel];

%%Return the least of these critical velocities
    vMax=min(v);
end