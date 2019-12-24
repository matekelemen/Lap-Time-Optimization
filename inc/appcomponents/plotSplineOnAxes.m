function [] = plotSplineOnAxes( ax, splx, sply, varargin )

    % Samples
    t       = linspace( 0, 1, 10*splx.pieces );
    
    % Plot specs
    if ~isempty(varargin)
        % Create plot handle
        if isa( varargin{1}, 'matlab.graphics.chart.primitive.Line' )
            k       = 2;
            plt     = varargin{1};
            set(plt,                                                    ...
                'XData', ppval(splx,t),                                 ...
                'YData', ppval(sply,t)                                  ...
                );
        else
            k       = 1;
            plt     = plot(ax, ppval(splx,t), ppval(sply,t) );
        end
        % Apply plot specs
        n = length(varargin);
        if n>k-1
            for k=k:2:n
                set(plt,varargin{k},varargin{k+1});
            end
        end
    else
        plot(ax, ppval(splx,t), ppval(sply,t) );
    end

end