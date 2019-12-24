dataCurvedRoad = load('sim3d_SpatialReferences.mat');
spatialRefCR = dataCurvedRoad.spatialReference.CurvedRoad;

figure(2)
fileName = 'sim3d_CurvedRoad.jpg';
I = imshow(fileName,spatialRefCR);
set(gca,'YDir','normal')
xlabel('X (m)')
ylabel('Y (m)')
 hold on

CL = readmatrix('Centerline.csv');
figure(2)
plot(CL(:,1),CL(:,2))