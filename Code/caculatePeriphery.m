function [Area,Xcenter,Ycenter,Perimeter]= caculatePeriphery(realData, imagData, enablePlot)

%%%%%% Inputs
% realPert : column vector -> real perturbation
% imagPert : column vector -> imaginary perturbation
% enablePlot : boolean -> set it to 1 to visualize data

%%%outputs
% Area, centroids and perimeter of convex hull

ConvexHullIndices=convhull(realData,imagData);

if enablePlot==1
    figure;
    plot_data(realData,imagData);
    hold on;
    plot(realData(ConvexHullIndices),imagData(ConvexHullIndices),'k-');
end

%         figure;

% geom : geometry, iner: intertia, cpmo: centroidal polar moment
[ geom, iner, cpmo ] = polygeom( realData(ConvexHullIndices),imagData(ConvexHullIndices));
Area= geom(1);
Xcenter=geom(2);
Ycenter=geom(3);
Perimeter=geom(4);
end