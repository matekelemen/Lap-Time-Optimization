function fig = plotTrack(track,varargin)
    % fig = plotTrack(track,varargin)
    % Plots the boundaries and the centerline of the input track
    % Optional: specify which curves to draw:
    %           - 'center'
    %           - 'bound1'
    %           - 'bound2'
    
    % Init
    holdStatus  = ishold;
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
    
    if nargin>1
        for k=1:nargin-1
            specs(varargin{k}) = true;
        end
    else
        specs('center') = true;
        specs('bound1') = true;
        specs('bound2') = true;
    end
    
    % Create figure
    fig = get(gcf);
    if isempty(fig.Children) | holdStatus
        hold on
    else
        figure
        hold on
    end
    
    % Centerline
    if specs('center')
        [splx,sply] = cubicSpline2D(track.center);
        plotSpline(splx,sply,'Color',[0.2,0.2,0.2],'LineWidth',0.2,'LineStyle','-.');
    end
    
    % Bound1
    if specs('bound1')
        [splx,sply] = cubicSpline2D(track.bound1);
        plotSpline(splx,sply,'Color',[0,0,0],'LineWidth',0.2,'LineStyle','-');
        plot(track.bound1(:,1),track.bound1(:,2),'k.','MarkerSize',8);
    end
    
    % Bound2
    if specs('bound2')
        [splx,sply] = cubicSpline2D(track.bound2);
        plotSpline(splx,sply,'Color',[0,0,0],'LineWidth',0.2,'LineStyle','-');
        plot(track.bound2(:,1),track.bound2(:,2),'k.','MarkerSize',8);
    end
    
    % Static points
    if isfield(track,'staticPoints')
        plot(                                                           ...
            track.center(track.staticPoints,1),                         ...
            track.center(track.staticPoints,2),                         ...
            'r.','MarkerSize',12);
    end
    
    % 
    pbaspect([1,1,1]);
    axis equal
    
    
    if ~holdStatus
        hold off
    end
    
    fig = gcf;

end