function [] = pathCombination(track,params1,params2,evaluator)
    % [] = pathCompare(track,params1,params2,evaluator)
    % Create figures on different linear combinations of the input paths
    
    % Init
    n           = 51;
    params      = zeros(length(track.bound1),n);
    objective   = zeros(1,n);
    blendParam  = linspace(0,1,n);
    
    % Plot init
    fig = plotTrack(track,'bound1','bound2');
    hold on
    
    % Compute path parameters and correponding objective values
    for k=1:n
        params(:,k)     = blendParam(k)*params1 + (1-blendParam(k))*params2;
        objective(k)    = evaluatePath(                                 ...
            track,                                                      ...
            params(:,k),                                                ...
            evaluator);
    end
    
    % Plot paths
    objectiveMax    = max(objective);
    objectiveNorm   = (objectiveMax-min(objective));
    for k=1:n
        color   = (objectiveMax-objective(k))/objectiveNorm;
        color   = [1-color,color,0];
        [splx,sply] = cubicSpline2D(generatePathPoints(                 ...
            track.bound1,                                               ...
            track.bound2,                                               ...
            params(:,k)));
        plotSpline(splx,sply,'Color',color);
    end
    

end