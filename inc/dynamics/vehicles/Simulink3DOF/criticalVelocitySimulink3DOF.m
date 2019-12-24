function vMax = criticalVelocitySimulink3DOF(curvature,mu)
    
    %% Information
    % This function returns the critical velocity of the Simulink 3DOF
    % model based on force and moment balance of the vehicle at the corner
    
    %% Inputs and Outputs
    % Input : Path curvatures [1/m] and static friction coefficient mu
    % Output : Critical velocity of cornering
    %% Vehicle data (3DOF model)
    g = 9.81;                       %% gravitational acceleration m/s^2

    mVehicle = 1575;                %% Mass of the entire vehicle
    mFR = 264.667;                  %%Load in kg on front right wheel
    mFL = 264.667;                  %%Load in kg on front left wheel

    mRR = 322;                      %%Load in kg on rear right wheel
    mRL = 322;                      %%Load in kg on rear left wheel

    b = 2;                          %%Track width

    h = 0.1340;                      %%Centre of gravity

    %mu = 1;                         %%Static friction 

    maxVel = 50 ;                   %%Maximum velocity achievable by the model
                                      %(Assumed to be capped to 50 m/s) 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%
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



    

