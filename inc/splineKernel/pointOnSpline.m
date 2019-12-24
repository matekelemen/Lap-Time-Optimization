function P = pointOnSpline( splx, sply, t )
    % points = pointOnSpline( splx, sply, t )
    % Returns points on the input spline at parameters t
    
    if size(t,2)>size(t,1)
        t = t';
    end

    P = [ ppval( splx, t ), ppval( sply, t ) ];

end