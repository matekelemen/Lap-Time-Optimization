x=0:0.4:15000;
x=x';
y=3.1250*ones(37501,1);
pathPoints=[x y];

velocities=1000*ones(37501,1);
splineParams=linspace(0,1,37501);
velocities(24000:end,1)=0.00000001;

% sim('controllerReference_accelerationTest.slx')
