function plotTrackOnAxes(ax, track,varargin)
    % fig = plotTrackOnAxes(ax,track,varargin)
    % Plots the boundaries and the centerline of the input track
    % Optional: specify which curves to draw:
    %           - 'center'
    %           - 'bound1'
    %           - 'bound2'
    
    hold(ax, 'on');
    
    % Init
    specs       = containers.Map(                                       ...
        {                                                               ...
            'center',                                                   ...
            'bound1',                                                   ...
            'bound2',                                                   ...
        },                                                              ...
        {                                                               ...
            false,                                                      ...
            false,                                                      ...
            false,                                                      ...
        }                                                               ...
    );
    if ~isempty(varargin)
        for k=1:length(varargin)
            specs(varargin{k}) = true;
        end
    else
        specs('center') = true;
        specs('bound1') = true;
        specs('bound2') = true;
    end
    
    % Centerline
    if specs('center')
        [splx,sply] = cubicSpline2D(track.center);
        plotSplineOnAxes(ax,splx,sply,'Color',[0.2,0.2,0.2],'LineWidth',0.2,'LineStyle','-.');
    end
    
    % Bound1
    if specs('bound1')
        [splx,sply] = cubicSpline2D(track.bound1);
        plotSplineOnAxes(ax,splx,sply,'Color',[0,0,0],'LineWidth',0.2,'LineStyle','-');
        plot(ax,track.bound1(:,1),track.bound1(:,2),'k.','MarkerSize',8);
    end
    
    % Bound2
    if specs('bound2')
        [splx,sply] = cubicSpline2D(track.bound2);
        plotSplineOnAxes(ax,splx,sply,'Color',[0,0,0],'LineWidth',0.2,'LineStyle','-');
        plot(ax,track.bound2(:,1),track.bound2(:,2),'k.','MarkerSize',8);
    end
    
    % Static points
    if isfield(track,'staticPoints')
        plot(   ax,                                                     ...
                track.center(track.staticPoints,1),                     ...
                track.center(track.staticPoints,2),                     ...
                'r.','MarkerSize',12);
    end
    
    % 
    pbaspect(ax,[1,1,1]);
    axis(ax, 'equal');
    hold(ax, 'off')

end