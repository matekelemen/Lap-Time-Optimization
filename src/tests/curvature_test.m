function pass = curvature_test()

    % Init
    radius1     = 5;
    radius2     = 10;
    offset      = [6,7];
    n           = 1001;
    
    pass        = true;
    tolerance   = 1e-4;
    
    % Create curve
    t1          = linspace(0,0.5*(1-1/n),n)';
    t2          = linspace(0.5,1,n)';
    points1     = radius1*[cos(2*pi*t1),sin(2*pi*t1)] + ones(n,1)*offset;
    points2     = radius2*[cos(2*pi*t2),sin(2*pi*t2)] + ones(n,1)*(offset+[radius2-radius1,0]);
    [splx,sply] = cubicSpline2D( [points1;points2] );
    
    t12         = splx.breaks( ceil(end/2) );
    
    % Resample
    n           = 100*n;
    t1          = linspace(0,t12*(1-1/n),n)';
    t2          = linspace(t12,1,n)';
    
    % Test
    k1          = curvature(splx,sply,t1);
    if norm(k1-1/radius1)/n>tolerance
        pass = false;
    end
    
    k2          = curvature(splx,sply,t2);
    if norm(k2-1/radius2)/n>tolerance
        pass = false;
    end

end