function [ sBrake ] = getDistanceOnSplineSegmentToDecelerate(velocities, acceleration,deceleration )

%   given maximum decelearation/acceleration of the vehicle and the ...
%   maximum velocities at the spline segment, the function
%   returns the distance on the current spline at which the vehicle has ...
%   to decelerate and the distance is stored in the array sBrake



velocities = evaluator.velocities;
%Need segment lengths of the splines as an array
%segLength= %%%

%sCritical=((vMaxN^2)-(vMaxC^2))/(2*deceleration);

sBrake=zeros();


%%For the first segment, where initial velocity is zero
vBrake=min(velocities(1),vMaxCar);

sAcc=(vBake*vBrake)/(2*acceleration);
sDece=((velocities(2)^2)-(vBrake^2))/(2*deceleation);


if sAcc>=segLength
    
    P=segLength-(velocities(2)^2/(2*d));
    Q= (1/(2*acceleration))-(1/(2*deceleration));
    
    R=P/Q;
    
    sBrake(1)=R/(2*acceleration);
    
end

if sAcc+sDece <= segLength
    
  sBrake(1)=segLength-sAcc;
    
end

%%Now looping over all segments starting from the second segment

for i=2:length(velocities)
    
%     A=[velocities(i-1) velocities(i) velocities(i+1) vMaxCar];
%     vBrake=min(A);

  vBrake=min(velocities(i),vMaxCar);
  
  sAcc=(vBrake*vBrake- velocities(i-1)^2)/(2*acceleration);
  sDece=((velocities(i+1)^2)-vBrake^2)/(2*deceleration);
  
  if sAcc>segLength || (segLength-sAcc)<sDece
      
      P=segLength+((velocities(i-1)^2)/(2*acceleration))+((velocities(i+1)^2)/(2*deceleration));
      Q= (1/(2*acceleration))-(1/(2*deceleration));
      R=P/Q;
      
     sBrake(i)=(R-velocities(i-1)^2)/(2*acceleration);
     
  else
      
     sBrake(i)=segLength-sDece; 
  end
  
    
end




end

