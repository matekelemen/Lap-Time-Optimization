function [trackPoints] = generateTrackPoints (trackData, initPoint, initHeading)

    % Init
    ds          = 2;
    heading     = initHeading;
    trackPoints = initPoint;
    pointNum    = 1;

    % Main loop
    for k=1:size(trackData, 1)
        
        if trackData(k, 1) == 0
            % Straight section
            [points, heading] = getPointsStraight(trackData(k,:), heading, trackPoints(pointNum, :));
        else
            % Circular section
            [points, heading] = getPointsCircle(trackData(k,:), heading, trackPoints(pointNum, :));
        end
        
        % Append points to output
        for l=1:size(points, 1)
            pointNum = pointNum + 1;
            trackPoints(pointNum, 1:2) = points(l,:);
        end
        
    end
    
    
    
    
    
    % Straight section
    function [points, heading] = getPointsStraight(data, heading, lastPoint)
        h = ds;
        points = (   h:h:data(2)    )';
        if ~isempty(points)
            if points(end) ~= data(2)
                points(end + 1) = data(2);
            end
        else
            points = data(2);
        end
        points = points * heading' + (  lastPoint' * ones(1, size(points, 1))  )';
    end

    % Circular section
    function [points, heading] = getPointsCircle (data, heading, lastPoint)
        h = ceil(ds/data(1));
        t = (    sign(data(2))*h*pi/180 : sign(data(2))*h*pi/180 : data(2)   )';
        if t(end) ~= data(2)
            t(end + 1) = data(2);
        end
        
        t0 = atan2(heading(2), heading(1));
        points = zeros(size(t, 2), 2);
        
        if data(2) > 0
            % Counter-clockwise
            for index=1:size(t, 1)
                points(index, :) = abs(data(1)) * [cos((t0 - pi/2) + t(index)), sin((t0 - pi/2) + t(index))];
            end
            points = points + (   abs(data(1))*[-heading(2); heading(1)] * ones(1, size(t, 1))   )';
            heading = [cos(t0 + t(end)); sin(t0 + t(end))];
        else
            % Clockwise
            for index=1:size(t, 1)
                points(index, :) = abs(data(1)) * [cos((t0 + pi/2) + t(index)), sin((t0 + pi/2) + t(index))];
            end
            points = points + (   abs(data(1))*[heading(2); -heading(1)] * ones(1, size(t, 1))   )';
            heading = [cos(t0 + t(end)); sin(t0 + t(end))];
        end
        points = points + (   lastPoint' * ones(1, size(t, 1))   )';
        
        
    end

end