function intk = objective_curvature(splx, sply, evaluator)
    % intk = objective_curvature(splx, sply, evaluator)
    % Returns the integral of the curvature of the spline over its entire 
    % length
    
    % Init
    t    = linspaceChain(splx.breaks,evaluator.nSubdivisions);
    
    % Integrate curvature over tspan
    curv = curvature(splx,sply,t);
    intk = trapz( t, curv.^2 );
    
    % Update evaluator
    if evaluator.writeDetails
        evaluator.curvatures    = curv;
        evaluator.splineParams  = t;
    end
    
end