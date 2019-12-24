function out = lineIntersection_test()

    a1              = [2;-1];
    b1              = [-4;3];
    a2              = [2;1];
    b2              = [-2;-3];
    test            = [3;-0.5];
    
    intersection    = lineIntersection(a1,b1,a2,b2);
    
    out = false;
    if abs(intersection(1)-test(1))<1e-10 && abs(intersection(2)-test(2))<1e-10
        out = true;
    end

end