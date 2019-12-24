function points = generatePathPoints(innerBound, outerBound, params)
    % pathPoints = generatePathPoints(innerBound, outerBound, params)
    % Returns path points from the input coefficients

    if size(params,2)>1
        params = params';
    end

    points = innerBound + (params*ones(1, 2)).*(outerBound - innerBound);
    
end