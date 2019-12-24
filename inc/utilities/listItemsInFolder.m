function itemNames = listItemsInFolder( parentFolder, varargin )
    % itemNames = listFolders( parentFolder, varargin )
    % Optional arguments:   any folder that contains at least one of the
    %                       provided strings

    itemNames     = dir(parentFolder);
    itemNames     = {itemNames.name};
    itemNames     = itemNames(3:end);
    
    if ~isempty(varargin)
        temp = zeros(size(itemNames));
        for k1=1:length(itemNames)
            for k2=1:length(varargin)
                if ~isempty( strfind(itemNames{k1}, varargin{k2}) )
                    temp(k1) = k1;
                end
            end
        end
        temp        = temp(temp~=0);
        itemNames = itemNames(temp);
    end
    
end