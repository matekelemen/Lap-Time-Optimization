function a = maxAccelerationOnPoint(v)

%    a =  max( 0, min(10,10-v/300*3.6) );
   a =  accelerationTable_McLarenF1(v);
%     a =  accelerationTable_linearVehicle(v);

end