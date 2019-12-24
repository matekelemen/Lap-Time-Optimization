function a = maxDecelerationOnPoint(v)

%    a = -4*(10-max( 0, min(10,10-v/300*3.6) ));
   a =  decelerationTable_McLarenF1(v);
%     a =  decelerationTable_linearVehicle(v);

end