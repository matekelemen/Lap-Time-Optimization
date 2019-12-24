function [] = plotSolution (track,params,evaluator,varargin)
    % plotSolution(track,params,evaluator,varargin)
    
    % Copy evaluator fields
    evalFields  = fields(evaluator);
    eval        = Evaluator();
    for k=1:length(evalFields)
        eval.(evalFields{k}) = evaluator.(evalFields{k});
    end
    eval.reset();
    eval.optimRange     = 0;
    eval.writeDetails   = true;
    
    % Init
    pathPoints  = generatePathPoints(track.bound1,track.bound2,params);
    [splx,sply] = cubicSpline2D(pathPoints);
    t           = linspaceChain(splx.breaks,eval.nSubdivisions);
    
    % Get velocities
    evaluatePath(track,params,eval);
    
    % Plot track
    plotTrack(track,'bound1','bound2');
    
    % Get path points
    pathPoints  = pointOnSpline(splx,sply,t);
    
    % Plot path
    hold on
    colorPlot(                                                          ...
        pathPoints(:,1),                                                ...
        pathPoints(:,2),                                                ...
        eval.velocities,                                                ...
        varargin{:}                                                     ...
        );
    colorbar;
    
    
    
    hold off
    

end