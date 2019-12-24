function options = parseOptimizationOptions(options)
    % options = parseOptimizationOptions(options)
    % Read modifiable options and convert them to optimoptions that can be
    % read into the optimization function

    % Create temporary cell array and fill field names
    temp            = cell( 2*length(options),1 );
    temp(1:2:end)   = options(:,1);
    
    % Convert field values if necessary and copy them in the temporary
    % array to form name-value pairs
    for k=2:2:length(temp)
        switch options{k/2,3}
            case 'numeric'
                temp{k}  = str2double(options{k/2,2});
            case 'symbolic'
                temp{k}  = eval(options{k/2,2});
            case 'char'
                temp{k}  = options{k/2,2};
            otherwise
                error(['Invalid setting type: ',options{k/2,3}])
        end
    end

    % Return optimoptions
    options = optimoptions('fmincon',temp{:});

end