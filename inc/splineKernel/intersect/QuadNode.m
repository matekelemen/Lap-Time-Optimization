classdef QuadNode < handle
    % Quadtree node for finding spline intersections
    % Children layout:
    %  _________
    % | 3  |  4 |
    % |____|____|
    % | 1  |  2 |
    % |____|____|
    
    properties
        x
        y
        children
        level
    end
    
    methods
        
        
        function node = QuadNode(parent,childID)
            node.children = QuadNode.empty(4,0);
            if isa(parent,'QuadNode')
                node.level      = parent.level+1;
                x               = parent.x( mod(childID,2)+1 );
                y               = parent.y( ceil(childID/2) );
                node.x          = [                                         ...
                    ( parent.x(1)+x )/2,                                    ...
                    ( x+parent.x(2) )/2                                     ...
                    ];
                node.y          = [                                         ...
                    ( parent.y(1)+y )/2,                                    ...
                    ( y+parent.y(2) )/2                                     ...
                    ];
            else
                node.level      = 1;
                node.x          = parent(1:2);
                node.y          = parent(3:4);
            end
        end % QuadNode
        
        
        function divide(this,target,maxLevel)
            % QuadNode.divide( targetFunction, maxLevel)
            % Subdivide current node into 4 subnodes and call divide on
            % them too, provided the targetFunction yields true on them.
            if this.level < maxLevel
                for k=1:4
                    this.children(k) = QuadNode(this,k);
                    if target(this.children(k))
                        this.children(k).divide(target,maxLevel);
                    end
                end
            end
        end % divide
        
        
        function inside = isInside(this,x,y)
            % QuadNode.isInside(x,y)
            % Returns true if the input point is within the cell
            inside = false;
            if this.x(1)<x && x<this.x(2)
                if this.y(1)<y && y<this.y(2)
                    inside = true;
                end
            end
        end % isInside
        
        
        function recursivePlot(this)
            if this.level == 1
                hold on
            end
            plot(                                                       ...
                this.x( [1,2,2,1,1] ),                                  ...
                this.y( [1,1,2,2,1] ),                                  ...
                'k'                                                     ...
                );
            if ~isempty(this.children)
                for k=1:4
                    this.children(k).recursivePlot();
                end
            end
        end
        
        
    end % methods
end % classdef

