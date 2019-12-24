function [newPoints, tsamples, staticPoints] = redistributePointsOnCurve(points, refinement, varargin)
    % [newPoints, tsamples, staticPoints] = redistributePoints( points, refinement, varargin )
    % Redistribute points on the spline defined by the input points
    % Sections with higher curvature will have points more densely packed
    % points        : original points on the curve to be redistributed  nx2
    % refinement    : control the number of new points generated
    %                 length(newPoints) = refinement*length(points)
    %
    % Optional arguments:
    %   'staticPoints'      : vector of indices that mark the boundaries of 
    %                         track sections (straight/curved sections)
    %   'section'           : index of section to be refined/redistributed,
    %                         if 0, all sections will be processed
    
    % Init
    if size(points,2) > size(points, 1)
        points          = points';
    end
    
    % Variable arguments
    kwargs = containers.Map(                                            ...
        {'staticPoints', 'section'},                                    ...
        { [1,length(points)], 0 }                                       ...
    );
    for key=kwargs.keys
        key = key{1};
        index = find( strcmp(varargin(1:2:end), key) );
        if ~isempty(index)
            kwargs( key ) = varargin{2*index};
        end
    end
    
    % Create spline through the original points
    [splx, sply]    = cubicSpline2D(points);
    
    % Get parameters of the static points
    tStatic         = splx.breaks( kwargs('staticPoints') );
    
    % Define region of interest
    ROI             = [0,1];
    staticPoints    = kwargs('staticPoints');
    if kwargs('section')>0
        ROI = [ splx.breaks( staticPoints(kwargs('section')) ),         ...
                splx.breaks( staticPoints(kwargs('section')+1) )];
    end
    
    % Number of new points (in the region of interest)
    N   = ceil(                                                         ...
        refinement*(                                                    ...
            sum(splx.breaks>=ROI(1) & splx.breaks<=ROI(2))              ...
            )                                                           ...
        );
    
    % Get curvatures and arc lengths
    T               = linspace(ROI(1),ROI(2),N);
    curv            = curvature(splx,sply,T);
    
    % Smoothen the curvature data
    frameLength     = ceil(N/10);
    if mod(frameLength,2)==0
        frameLength = frameLength+1;
    end
    degree          = max( 0, min(3,frameLength-1) );
    curv            = abs(sgolayfilt(curv,degree,frameLength));
    
    % Parameter steps
    dt              = ( curv + mean(curv) );
    % Get parameters
    tsamples        = cumtrapz(T,dt);
    % Map parameters to interval
    tsamples        = interp1( tsamples, T, linspace(0,tsamples(end),N)  );
    % Add static points and original points outside the ROI
    tsamples        = uniquetol(sort( [
        tsamples,                                                       ...
        tStatic,                                                        ...
        splx.breaks( splx.breaks<ROI(1) ),                              ...
        splx.breaks( splx.breaks>ROI(2) )                               ...
        ] ), 1e-15);
    % Update static point indices
    staticPoints    = find( ismembertol(tsamples,tStatic,1e-15) );
    % Get new points
    newPoints       = pointOnSpline( splx, sply, tsamples );

    % DEBUG - plot
%     colorPlot(                                                          ...
%         newPoints(:,1),                                                 ...
%         newPoints(:,2),                                                 ...
%         curvature(splx,sply,tsamples),                                  ...
%         'Marker','.',                                                   ...
%         'LineStyle','none'                                              ...
%         );
%     axis equal
end