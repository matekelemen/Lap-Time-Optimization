function out = lineThroughNode_test()

    root = QuadNode([0 1 0 1],1);
    
    a = [ linspace(-1,1,20); ones(1,20) ];
    b = [ 0, 1 ];
    test = [ones(1,10),zeros(1,10)];
    
    out = true;
    for k=1:20
        if lineThroughNode( root,a(:,k),b )~=test(k)
            out = false;
            return
        end
    end

end