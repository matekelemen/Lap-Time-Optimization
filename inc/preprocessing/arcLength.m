function l = arcLength ( splx, sply, t)
    % l = arcLength ( splx, sply, t)
    % Returns the arc length of the cubic spline at the given parameter(s)
    % The input parameters must be sorted in ascending order

    if size(t,2) > size(t,1)
        t = t';
    end
    % Check if parameters are sorted
    if ~issorted(t)
        t = sort(t);
    end
    
    % Init
    N       = 5;    
    n       = length(t);
    l       = zeros( n, 1 );
    tspan   = cell(n-1,1);
    indices = zeros(n-1,1,'uint64');
    
    for i=1:n-1
        
        % Find breaks
        k1      = find(splx.breaks>=t(i),1,'first');
        k2      = find(splx.breaks<=t(i+1),1,'last');

        % Samples
        breaks  = [t(i),splx.breaks(k1:k2),t(i+1)];
        if breaks(1)==breaks(2)
            breaks(1) = [];
        end
        if breaks(end-1)==breaks(end)
            breaks(end)=[];
        end
        tspan{i}    = linspaceChain(breaks,N);
        indices(i)  = length(tspan{i});
        
    end
    
    % Start indices
    indices     = [0;cumsum(indices)];
    
    % Merge tspan
    tspan       = cell2mat(tspan');

    % Compute arc lengths
    dx  = ppval( fnder(splx,1), tspan );
    dy  = ppval( fnder(sply,1), tspan );
    for k=1:n-1
        rng     = indices(k)+1:indices(k+1);
        dX      = vecnorm([dx(rng);dy(rng)]);
        l(k+1)  = l(k) + trapz(tspan(rng),dX);
    end
    
    

end