function out = lineThroughNode(node,a,b)
    % out = lineThroughCell(node,a,b)
    % Returns true if the line, specified by the parameters a and b
    % ([x,y]=at+b), has any points in the input node
    
    % Select to test for horizontal or vertical grid lines
    if abs(a(1))>abs(a(2))
        k1      = 2;
        k2      = 1;
        cmin    = node.y(1);
        cmax    = node.y(2);
        tmin    = node.x(1);
        tmax    = node.x(2);
    else
        k1      = 1;
        k2      = 2;
        cmin    = node.x(1);
        cmax    = node.x(2);
        tmin    = node.y(1);
        tmax    = node.y(2);
    end
    
    % Get intersection coordinates
    intersect1  = a(k2)*( cmin-b(k1) )/a(k1) + b(k2);
    intersect2  = a(k2)*( cmax-b(k1) )/a(k1) + b(k2);
    
    % Test
    out = true;
    if intersect1>=tmax && intersect2>=tmax
        out = false;
    elseif intersect1<=tmin && intersect2<=tmin
        out = false;
    end

end