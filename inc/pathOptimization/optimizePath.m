function [globParams,track] = optimizePath(varargin)
    % [globParams,track] = optimizePath(varargin)
    % Optional arguments:
    %   x0              : initial solution
    %   track           : track to be optimized on
    %   evaluator       : instance of the Evaluator class
    %   optimoptions    : optimoptions for fmincon
    %   axesHandle      : axes handle of the GUI
    
    %% INIT
    
    % Check input size
    if mod(numel(varargin),2)~=0
        error('Inputs have to be property-value pairs')
    end
    
    % Check whether the app is running
    app = [];
    try
        app = evalin('base','app');
    catch exception
        
    end
    
    %% DEFAULT ARGUMENTS
    
    % Default track (double bend)
    index   = find( strcmp(varargin,'track') );
    if ~isempty(index)
        track       = varargin{index+1};
    else
        track       = track_DoubleBend();
    end
    
    % Default evaluator (curvature optimization)
    index   = find( strcmp(varargin,'evaluator') );
    if ~isempty(index)
        evaluator   = varargin{index+1};
    else
        evaluator                   = Evaluator();
        evaluator.targetFunction    = @objective_curvature;
    end
  
    if evaluator.optimRange>0
        optimRange  =   track.staticPoints(evaluator.optimRange) :      ...
                        track.staticPoints(evaluator.optimRange+1);
    else
        optimRange = 1:length(track.bound1);
    end
    
    % Default initial path (centerline)
    index   = find( strcmp(varargin,'x0') );
    if ~isempty(index)
        x0          = varargin{index+1};
    else
        x0          = 0.5*ones(length(optimRange),1);
    end
    
    
    % Default plot handle
    index   = find( strcmp(varargin,'axesHandle') );
    if ~isempty(index)
        axesHandle  = varargin{index+1};
        cla(axesHandle)
    else
        clf;
        axesHandle  = gca;
        set(axesHandle,'units','normalized','outerposition',[0 0 1 1]);
    end
    
    
    % Optimoptions
    index   = find( strcmp(varargin,'optimoptions') );
    if ~isempty(index)
        % optimoptions specified, parse OutputFcn
        % (necessary because @progressPlot is defined in this script and
        % cannot be accessed from outside)
        problem.options = varargin{index+1};
        if ~isempty(problem.options.OutputFcn) && isequal(problem.options.OutputFcn,@ProgressPlot)
            problem.options.OutputFcn   = @progressPlot;
        end
    else
        problem.options = optimoptions(                                 ...
        'fmincon',                                                      ...
        'algorithm','interior-point',                                   ...
        'MaxFunctionEvaluations', 1e9,                                  ...
        'OptimalityTolerance',1e-8,                                     ...
        'StepTolerance',1e-9,                                           ...
        'UseParallel',true,                                             ...
        'OutputFcn',@progressPlot,                                      ...
        'Display','iter'                                                ...
        );
    end
    
    problem.solver  = 'fmincon';
    
    %% APPLY CONSTRAINTS
    
    problem.x0      = x0;                           % <--- Initial path
    problem.lb      = zeros(length(problem.x0), 1); % <--- alpha >= 0
    problem.ub      = ones(length(problem.x0), 1);  % <--- alpha <= 1

    % Target function (reduce the number of arguments to 1)
    problem.objective = @(x) evaluatePath(                              ...
            track,                                                      ...
            x,                                                          ...
            evaluator                                                   ...
        );

    %% PLOT TRACK
    % Plot bounds (points)
    plotTrackOnAxes(axesHandle,track,'bound1','bound2');
    hold(axesHandle,'on')
    
    axis(axesHandle, 'equal')
    title(axesHandle,'PATH');
    
    % Plot path
    pathPlot    = plot(axesHandle,nan,nan);
    hold(axesHandle,'off')
    
    %% PARALLEL SETUP
    
    % Set up parallel processing if requested (and if not already set up)
    if problem.options.UseParallel && max(size(gcp)) == 0
        parpool
    end

    %% RUN OPTIMIZATION 
    
    % Set norm (objective value for x0)
    % -->   the objective will be normalized by this value 
    %       while the optimization is under execution
    evaluator.norm  = problem.objective(problem.x0)                     ...
                      /length(track.bound1)/evaluator.objectiveMultiplier;
    
    % Start timer
    tic
    % Run optimizer
    params          = eval( [problem.solver,'(problem)'] );
    
    % Assemble global params (only for sectionwise optimization)
    if evaluator.optimRange>0
        rng         = track.staticPoints(evaluator.optimRange)          ...
                      :                                                 ...
                      track.staticPoints(evaluator.optimRange+1);
        globParams        = evaluator.params;
        globParams(rng)   = params;
    else 
        globParams = params;
    end
    
     %% POSTPROCESS
     
    % Plot solution
    [splx,sply] = cubicSpline2D(generatePathPoints(                     ...
        track.bound1,                                                   ...
        track.bound2,                                                   ...
        globParams)');
    hold(axesHandle,'on')
    plotSplineOnAxes(axesHandle,splx,sply,'Color',[0,1,0],'LineWidth',0.3);
    %legend(axesHandle,'Bounds','Bounds','Trajectory');
    hold(axesHandle,'off')
    
    % Print optimization target and elapsed time
    disp([                                                              ...
        'Optimization target: ',                                        ...
        num2str( evaluator.norm * problem.objective(params) )           ...
        ])
    disp([                                                              ...
        'Processing duration: ',                                        ...
        num2str( toc ),                                                 ...
        '[s]'                                                           ...
        ])
    
    
    
    %% FUNCTION DEFINITIONS -----------------------------------------------
    function stop = progressPlot(x,optimValues,state)
        
        % Get all parameters if optimizing sectionwise
        if evaluator.optimRange>0
            rng         = track.staticPoints(evaluator.optimRange)      ...
                          :                                             ...
                          track.staticPoints(evaluator.optimRange+1);
            temp        = evaluator.params;
            temp(rng)   = x;
            x           = temp;
        end
        
        % Generate data for the plot
        iter        = num2str(optimValues.iteration);
        pts         = generatePathPoints(track.bound1,track.bound2,x);
        [sx,sy]     = cubicSpline2D(pts);
        
        % Update plot
        plotSplineOnAxes(   axesHandle,                                 ...
                            sx,                                         ...
                            sy,                                         ...
                            pathPlot,                                   ...
                            'Color',[0,1,0],                            ...
                            'LineWidth',0.15    );
                        
        set(pathPlot.Parent.Title,                                      ...
            'String',                                                   ...
            ['PATH (iter ',iter,')']                                    ...
            );
        
        % Draw and save figure
        drawnow
%         saveas(fig,['doc/figureOutput/iter',iter,'.png'],'png');
        
        % Check termination request from the app
        stop = false;
        if ~isempty(app)
            stop = app.terminateOptimization;
        end
    end
    
end