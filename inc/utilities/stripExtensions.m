function paths = stripExtensions(paths,varargin)
    % paths = stripExtensions(paths,varargin)
    % Strip extensions from all file names in the paths cell array
    % Optional arguments:    specific extensions to strip
    
    for k=1:length(paths)
        
        subString   = {'.'};
        
        if ~isempty(varargin)
            subString = varargin;
        end
        
        for k2=1:length(subString)
            index = strfind( paths{k}, subString{k2} );
            if ~isempty(index) && index>1
                paths{k} = paths{k}(1:index-1);
                break;
            end
        end
        
    end
    

end