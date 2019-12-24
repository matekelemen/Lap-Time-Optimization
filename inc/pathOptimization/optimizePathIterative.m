function [params,track,timing] = optimizePathIterative(evaluatorGlobal,evaluatorLocal,refinement,varargin)
    % [params,track,timing] = optimizePathIterative(evaluatorGlobal,evaluatorLocal,refinement,varargin)

    %% INIT
    evalIndex               = find(strcmp(varargin,'evaluator'));
    if ~isempty(evalIndex)
        varargin{evalIndex+1} = evaluatorGlobal;
    else
        varargin{end+1}     = 'evaluator';
        varargin{end+1}     = evaluatorGlobal;
    end
    
    log = { {'Global optimization'}, {'Local optimization'} };
    
    %% INITIAL OPTIMIZATION (GLOBAL)
    timing.globOptStart     = tic;
    log{1}{end+1}           = timing.globOptStart;
    
    try
        [params,track]          = optimizePath(varargin{:});
    catch exception
        log{1}{end+1} = exception;
    end
    
    timing.globOptEnd       = toc;
    log{1}{end+1}           = timing.globOptEnd;
    
    %% SECTIONWISE OPTIMIZATION (LOCAL)
    % Update x0
    evalIndex               = find(strcmp(varargin,'x0'));
    if ~isempty(evalIndex)
        varargin{evalIndex+1}   = params;
    else
        varargin{end+1}         = 'x0';
        varargin{end+1}   = params;
    end
    
    % Switch evaluator
    evalIndex               = find(strcmp(varargin,'evaluator'));
    evaluatorLocal.params   = params;
    varargin{evalIndex+1}   = evaluatorLocal;
    
    % Run optimization
    timing.locOptStart      = tic;
    log{2}{end+1}           = timing.locOptStart;
    
    try
        for k=1:length(track.staticPoints)-1
            % Reset norm
            evaluatorLocal.norm = 1.0;
            % Refine track section
            sectionIndices  = track.staticPoints(k):track.staticPoints(k+1);
            track           = redistributePointsOnTrack(                    ...
                                track,                                      ...
                                refinement,                                 ...
                                'section',                                  ...
                                k);
            % Fill parameters for new track points
            temp    = 0.5*ones( track.staticPoints(k+1)-track.staticPoints(k)+1,1 );
            evaluatorLocal.params        = [                                ...
                evaluatorLocal.params( 1:sectionIndices(1)-1 );             ...
                temp;                                                       ...
                evaluatorLocal.params( sectionIndices(end)+1:end ) ];
            % Update track
            trackIndex                   = find( strcmp(varargin,'track') );
            varargin{trackIndex+1}       = track;
            % Update x0
            trackIndex                   = find( strcmp(varargin,'x0') );
            varargin{trackIndex+1}       = temp;
            % Section index
            evaluatorLocal.optimRange    = k;
            evaluatorLocal.params        = optimizePath(varargin{:});
        end
    catch exception
        log{2}{end+1} = k;
        log{2}{end+1} = exception;
    end
    
    
    params  = evaluatorLocal.params;
                
    
    timing.locOptEnd            = toc;
    log{2}{end+1}               = timing.locOptEnd;
    
    %% LOG
    fileName = datestr(datetime);
    fileName(fileName==':') = '-';
    save(['doc/resultOutput/log/',fileName]);
    
    %% TERMINATION DISPLAY
    fprintf('\n\n');
    disp(['Initial processing duration: ',num2str(timing.globOptEnd)])
    disp(['Sectioned processing duration: ',num2str(timing.locOptEnd)])

end