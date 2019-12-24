function curv = curvature ( splx, sply, t )
    % k = curvature( splx, sply, t )
    % Returns the curvature of the cubic spline at the given parameter(s)
    
    % Init
    if size(t,2) > size(t,1)
        t = t';
    end
    
    % First derivatives
    DX = fnder(splx, 1);
    DY = fnder(sply, 1);
    
    dx = ppval( DX, t );
    dy = ppval( DY, t );
    
    % Second derivatives
    ddx = ppval( fnder(DX, 1), t );
    ddy = ppval( fnder(DY, 1), t );
    
    % Curvature
    curv =  abs( dx.*ddy - ddx.*dy )                                    ...
            ./                                                          ...
            (( dx.*dx + dy.*dy ).^(1.5));
   
end