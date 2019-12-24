classdef TableLookup < handle
    % Table lookup with initializable database
    % instance = TableLookup(dataFilePath, varargin)
    % Instantiate a TableLookup with a database to look up from
    % Optional argument: lookup method:
    %   'interp1'       : use interp1 with added infinite bounds
    %   'linearSearch'  : use a linear search with linear
    %                     interpolation
    
    
    properties
        data                % Lookup table to read from
        method              % Method of lookup and interpolation
    end
    
    
    methods
       
        function instance = TableLookup(dataFilePath, varargin)
            % instance = TableLookup(dataFilePath, varargin)
            % Instantiate a TableLookup with a database to look up from
            % Optional argument: lookup method:
            %   'interp1'       : use interp1 with added infinite bounds
            %   'linearSearch'  : use a linear search with linear
            %                     interpolation
            
            % Read data and add infinite bounds
            instance.data       = csvread(dataFilePath);

            % Parse method
            instance.method     = 'interp1';
            if ~isempty(varargin)
                if length(varargin)==1
                    instance.method = varargin{1};
                else
                    error('Too many input arguments!')
                end
            end
            
            % Set interpolation method
            switch instance.method
                case 'interp1'
                    % Set method to interp1
                    instance.method = @(x) instance.builtInInterp1(x);
                case 'linearSearch'
                    % Set method to interpolation member function
                    instance.method = @(x) instance.interpolate(x);
                otherwise
                    error('Inalid lookup method')
            end
            
            
        end
        
        
        function values = builtInInterp1(instance, x)
            % Interpolate all
            values  = interp1( instance.data(:,1), instance.data(:,2), x );
            % Extrapolate out-of-bound values
            values( x<=instance.data(1,1) )     = instance.data(1,2);
            values( x>=instance.data(end,1) )   = instance.data(end,2);
            % Catch outliers
%             if sum(isnan(values))>0
%                 error('Invalid interpolation!')
%             end
        end
        
        
        function values = interpolate(instance, x)
            % values = interpolate(instance, x)
            % Perform a linear search with interpolation on the data
            
            % Prealloc
            values = zeros(size(x));
            % Search and interpolate
            for k=1:length(values)
                if x(k)<=instance.data(1,1)
                    v = instance.data(1,2);
                elseif x(k)>=instance.data(end,1)
                    v = instance.data(end,2);
                else
                    v = find(instance.data(:,1)<=x(k),1,'last');
                    v = instance.data(v,2) +                            ...
                        (instance.data(v+1,2)-instance.data(v,2)) /     ...
                        (instance.data(v+1,1)-instance.data(v,1)) *     ...
                        (x(k)-instance.data(v,1));
                end

                values(k)   = v;
            end
        end
        
        
        % Overload every operator() to perform the lookup
%         function values = subsindex(instance, x)
%             values = instance.method(x);
%         end
%         
%         
%         function values = subsasgn(instance, x, values)
%             values = instance.method(x);
%         end
%         
%         
%         function values = subsref(instance, x)
%             values = instance.method(x);
%         end
        
    end
    
end