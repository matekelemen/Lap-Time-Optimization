function pass = arcLength_test()

    % Init
    pass        = true;
    tolerance   = 1e-5;
    n           = 51;
    
    % Create curve
    t           = linspace(0,1,n)';
    [splx,sply] = cubicSpline2D([cos(2*pi*t),sin(2*pi*t)]);
    
    % Test
    L           = diff( arcLength(splx,sply,[0,1]) );
    if abs(L-2*pi)>tolerance
        pass = false;
    end
    
end