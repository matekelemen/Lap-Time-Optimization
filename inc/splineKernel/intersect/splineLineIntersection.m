function [intersection,t] = splineLineIntersection(splx,sply,a,b,tolerance,varargin)
    % [intersection,t] = splineLineIntersection(splx,sply,a,b,tolerance,(tspan))
    % Find the intersection of a spline and a line within the specified
    % tolerance
    % Line definition: [x;y] = at+b
    % Optional argument: tspan (spline parameter search range)

    % Init
    if ~isempty(varargin)
        t = varargin{1};
    else
        t       = [0,1];
    end
    points  = pointOnSpline(splx,sply,t);
    
    % Bisection
    while norm(diff(points))>tolerance
        % First half
        T       = [t(1),(t(1)+t(2))/2];
        points  = pointOnSpline(splx,sply,T);
        [intersection,tau] = lineIntersection(                          ...
            diff(points)',                                              ...
            points(1,:)',                                               ...
            a,                                                          ...
            b                                                           ...
        );
        if ~isempty(tau)
            if 0<=tau(1) && tau(1)<=1
                t = T;
                continue;
            end
        end
        % Second Half
        T       = [T(2),t(2)];
        points  = [ points(2,:); pointOnSpline(splx,sply,T(2)) ];
        [intersection,tau] = lineIntersection(                          ...
            diff(points)',                                              ...
            points(1,:)',                                               ...
            a,                                                          ...
            b                                                           ...
        );
        if ~isempty(tau)
            if 0<=tau(1) && tau(1)<=1
                t = T;
                continue;
            else
                error('Line intersection out of range')
            end
        else
            error('Could not continue bisection')
        end
    end
    
    t = mean(t);
end