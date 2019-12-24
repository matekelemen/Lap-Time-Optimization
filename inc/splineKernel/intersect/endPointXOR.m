function out = endPointXOR( point1, point2, quadNode )

    p1  = quadNode.isInside( point1(1), point1(2) );
    p2  = quadNode.isInside( point2(1), point2(2) );
    out = xor(p1,p2);

end