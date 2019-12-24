function vec = linspaceChain(breaks,n)
    % vec = linspaceChain(breaks,n)
    % Returns linspaces between the components of breaks with n elements
    % between each two components
    
    % Init
    N   = length(breaks)-1;
    vec = zeros(1,(n-1)*N+1);
    
    % Fill
    for k=1:N
        rng         = (n-1)*(k-1)+1 : (n-1)*k+1;
        vec(rng)    = linspace(breaks(k),breaks(k+1),n);
    end
    
end