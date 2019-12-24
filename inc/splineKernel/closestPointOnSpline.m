function [t,points] = closestPointOnSpline(splx,sply,points)
    % [t,point] closestPointOnSpline(splx,sply,points)
    % Find the nearest points to 'points' on the 2D spline defined by splx
    % and sply, based on a global minimization technique.
    % This function needs revision (speed and robustness)!
    
    % Number of initial samples = spline length [m]
    n               = ceil(diff( arcLength(splx, sply, [0;1]) ));
    T               = linspace(0,1,n)';
    
    splinePoints    = pointOnSpline(splx,sply,T);
    
    % Init
    t               = zeros( size(points,1) ,1);
    rng             = 1/n;
    dt              = 51;
    
    % Find minimum distance to target points
    for k=1:size(points,1)
        % Find the closest initial point
        d   = splinePoints - ones(length(splinePoints),1) * points(k,:);
        d   = vecnorm(d');
        [minVal,minIndex] = min(d);
        t(k)= T(minIndex);
        temp= t(k);
        % Refine result
        tspan   = [ max(0,t(k)-rng), min(t(k)+rng,1) ];
        tspan   = linspace(tspan(1),tspan(2),dt);
        d       = pointOnSpline(splx, sply, tspan);
        d(:,1)  = d(:,1)-points(k,1);
        d(:,2)  = d(:,2)-points(k,2);
        d       = diff(vecnorm(d'));
        t(k)    = interp1( d, (tspan(1:end-1)+tspan(2:end))/2, 0);
        if isnan(t(k))
            t(k) = temp;
        end
    end
    
    points  = pointOnSpline(splx,sply,t);

end