function [] = plotSolutionOnAxes (ax,track,params,evaluator)
    % plotSolution(ax,track,params,evaluator,varargin)
    % This version of the function needs evaluator to be filled with data
    
    % Init
    pathPoints  = generatePathPoints(track.bound1,track.bound2,params);
    [splx,sply] = cubicSpline2D(pathPoints);
    t           = evaluator.splineParams;
    
    % Plot track
    plotTrackOnAxes(ax,track,'bound1','bound2');
    
    % Get path points
    pathPoints  = pointOnSpline(splx,sply,t);
    
    % Plot path
    hold(ax,'on');
    
    colorPlot(                                                          ...
        pathPoints(:,1),                                                ...
        pathPoints(:,2),                                                ...
        evaluator.velocities,                                           ...
        'Parent',ax                                                     ...
        );
    colorbar(ax);
    
    hold(ax,'off');
end