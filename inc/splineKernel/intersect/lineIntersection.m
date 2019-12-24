function [intersection,t] = lineIntersection( a1,b1, a2,b2 )
    % [intersection,t] = lineIntersection( a1,b1, a2,b2 )
    % Returns the intersection point of two lines defined by the input
    % arguments. Line equation: [x,y]=at+b

    % Init
    if size(a1,2)>size(a1,1)
        a1 = a1';
    end
    if size(b1,2)>size(b1,1)
        b1 = b1';
    end
    if size(a2,2)>size(a2,1)
        a2 = a2';
    end
    if size(b2,2)>size(b2,1)
        b2 = b2';
    end
    
    % Solve
    A = [a1,-a2];
    if abs(det(A))>1e-14
        t = A\(b2-b1);
        intersection = a1*t(1)+b1;
    else
        intersection = [];
        t = [];
    end
    
end