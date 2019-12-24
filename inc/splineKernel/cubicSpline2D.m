function [splx, sply] = cubicSpline2D(points)
    % [splx, sply] = cubicSpline2D(points)
    % Returns two cubic splines for interpolating the x and y coordinates
    % of the input points
    
    % Init
    if size(points, 2) < size(points,1)
        points = points';
    end

    % Get parameters
    d = sqrt( vecnorm(diff(points')') );
    d = [0, cumsum(d)/sum(d)];
    
    % Generate splines
    splx = spline( d, points(1,:) );
    sply = spline( d, points(2,:) );

end