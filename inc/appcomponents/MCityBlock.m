function MCityBlock(outFileName)

    pts = [];

    data = load('sim3d_SpatialReferences.mat');
    spatialRef = data.spatialReference.USCityBlock;    
    
    fileName = 'sim3d_USCityBlock.jpg';
    I = imshow(fileName,spatialRef);
    set(gca,'YDir','normal')
    xlabel('X (m)')
    ylabel('Y (m)')
    
    set(I,'ButtonDownFcn',@(img,event)registerPoint(img,event));
    
    
    
    
    function registerPoint(image,event)
        point = event.IntersectionPoint(1:2);
        pts(end+1,1:2) = point;
        csvwrite(outFileName,pts);
    end

end