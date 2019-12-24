function track = buildTrack (track, centerSpec, widthFun)
    % track = buildTrack (track, centerSpec, widthFun)
    % Build a track section-by-section. Specify the points on the center
    % line and a width function (parameter range [0,1]). Returns the
    % updated track structure.
    % track
    %               .bound1
    %               .bound2
    %               .center
    %               .lastPoint
    %               .lastHeading
    %               .staticPoints
    
    % Init
    if ~isfield(track,'bound1')
        track.bound1                = [];
    end
    if ~isfield(track,'bound2')
        track.bound2                = [];
    end
    if ~isfield(track,'center')
        track.center                = [];
        track.staticPoints          = 1;
    end
    
    % Get center points and normals
    if centerSpec(1)==0
        % Straight section
        [center, heading, normal] = getPointsStraight(centerSpec,track.lastHeading, track.lastPoint);
    else
        % Circular arc
        [center, heading, normal] = getPointsCircle(centerSpec,track.lastHeading, track.lastPoint);
    end
    
    % Get boundary points
    bound1 = center;
    bound2 = center;
    T = linspace(0,1,length(center));
    for k=1:length(center)
        bound1(k,:) = bound1(k,:) + widthFun(T(k))/2 * normal(k,:);
        bound2(k,:) = bound2(k,:) - widthFun(T(k))/2 * normal(k,:);
    end
    

    % Update track structure
    track.bound1 = [track.bound1;bound1];
    track.bound2 = [track.bound2;bound2];
    track.center = [track.center;center];
    
    track.lastPoint = track.center(end,:);
    track.lastHeading = heading;
    
    track.staticPoints = [ track.staticPoints; length(track.center) ];
    
    
    
    % Function definitions ------------------------------------------------
    
    % Straight section
    function [points, heading, normal] = getPointsStraight(data, heading, lastPoint)
        h = 2;
        points = (   h:h:data(2)    )';
        if ~isempty(points)
            if points(end) ~= data(2)
                points(end + 1) = data(2);
            end
        else
            points = data(2);
        end
        points = points * heading' + (  lastPoint' * ones(1, size(points, 1))  )';
        normal = ones(size(points,1),1) * [-heading(2),heading(1)];
    end





    % Circular section
    function [points, heading,normal] = getPointsCircle (data, heading, lastPoint)
        h = 2/data(1) *180/pi;
        t = (    sign(data(2))*h*pi/180 : sign(data(2))*h*pi/180 : data(2)   )';
        if ~isempty(t)
            if t(end) ~= data(2)
                t(end + 1) = data(2);
            end
        else
            t = data(2);
        end
        
        t0 = atan2(heading(2), heading(1));
        points = zeros(size(t, 2), 2);
        normal = points;
        
        if data(2) > 0
            % Counter-clockwise
            for index=1:size(t, 1)
                points(index, :) = abs(data(1)) * [cos((t0 - pi/2) + t(index)), sin((t0 - pi/2) + t(index))];
                normal(index,:) = [-sin((t0) + t(index)),cos((t0) + t(index))];
            end
            points = points + (   abs(data(1))*[-heading(2); heading(1)] * ones(1, size(t, 1))   )';
            heading = [cos(t0 + t(end)); sin(t0 + t(end))];
        else
            % Clockwise
            for index=1:size(t, 1)
                points(index, :) = abs(data(1)) * [cos((t0 + pi/2) + t(index)), sin((t0 + pi/2) + t(index))];
                normal(index,:) = [-sin((t0) + t(index)),cos((t0) + t(index))];
            end
            points = points + (   abs(data(1))*[heading(2); -heading(1)] * ones(1, size(t, 1))   )';
            heading = [cos(t0 + t(end)); sin(t0 + t(end))];
        end
        points = points + (   lastPoint' * ones(1, size(t, 1))   )';
        
        
    end
    
    
end