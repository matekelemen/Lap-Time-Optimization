function [] = colorPlot(x,y,color,varargin)

    attributes =                                                        ...
        {                                                               ...
            'Marker','none',                                            ...
            'MarkerSize',6,                                             ...
            'LineStyle','-'                                             ...
            'LineWidth',0.5 };
    
    if ~isempty(varargin)
        for k=1:2:length(attributes)
            index = 2*find(strcmp( varargin(1:2:end), attributes{k} ));
            if isempty(index)
                varargin{end+1} = attributes{k};
                varargin{end+1} = attributes{k+1};
            end
        end
    else
        for k=1:2:length(attributes)
            varargin{end+1} = attributes{k};
            varargin{end+1} = attributes{k+1};
        end
    end
    
    if isempty(color) || length(color)~=length(x)
        color = zeros(length(x),1);
    end

    %% Trick surface into a 2-D plot
    % XYZC Data must have at least 2 cols
    surface('XData', [x x],                                             ...  
            'YData', [y y],                                             ...
            'ZData', zeros(numel(x),2),                                 ...
            'CData', [color color],                                     ...
            'FaceColor', 'none',                                        ...
            'EdgeColor', 'interp',                                      ...
            varargin{:} );
    
end