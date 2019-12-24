function out = avgRefine(in)
    % out = refineAvg(in)
    % Return the input vector with averages in between its components

    % Init
    out             = zeros(2*size(in)-1);
    
    % Original values
    out(1:2:end)    = in;
    
    % Average values
    out(2:2:end)    = (in(1:end-1)+in(2:end))/2;

end