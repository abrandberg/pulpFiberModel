function [Width, Height,A,Iyy] = inertiaCalculation(innerRadiusNodesFile,outerRadiusNodesFile,debugFlag)
%inertiaCalculation(innerRadiusNodesFile,outerRadiusNodesFile,debugFlag) 
%calculates the second area moment of inertia based on the outer and inner
%boundary of a set of nodes. The nodes are already grouped into an outer and 
%an inner set, but are unorded.
%
% INPUT:        innerRadiusNodesFile - Self-explanatory. Format should be
%               outerRadiusNodesFile - -""-          
%               debugFlag            - Can be used to plot the algorithm to
%                                      find mistakes. 
%
% OUTPUT:       Width       - Unit [mu*m]
%               Height      - Unit [mu*m]
%               A           - Area [mu*m]^2
%               Iyy         - Second moment of inertia around the first ("X")
%                             axis, with the coordinate system in geometric 
%                             CG.  
%              
% REMARKS:
%
% TO DO:
%
% created by: August Brandberg
% date: 08-04-2018
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

innerNodes = importCrossSection(innerRadiusNodesFile);
outerNodes = importCrossSection(outerRadiusNodesFile);

if debugFlag == 1
    figure
    plot(innerNodes(:,2),innerNodes(:,3),'o','displayname','Recorded lumen contour')
    hold on
    plot(outerNodes(:,2),outerNodes(:,3),'s','displayname','Recorded outer fiber contour')
    axis([-20 20 -15 5])
    xlabel('X coordinate [\mum]')
    ylabel('Y coordinate [\mum]')  
end

% The nodes are ordered according to ANSYS logic. Reorder them to form a
% convex hull.
[K,V] = boundary(innerNodes(:,2),innerNodes(:,3));
[geomInner, inerInner, cpmoInner] = polygeom(innerNodes(K,2),innerNodes(K,3));

[K,V] = boundary(outerNodes(:,2),outerNodes(:,3));
[geomOuter, inerOuter, cpmoOuter] = polygeom(outerNodes(K,2),outerNodes(K,3));

if debugFlag == 1
    plot(innerNodes(K,2),innerNodes(K,3),'-b','displayname','Fitted lumen contour')
    plot(outerNodes(K,2),outerNodes(K,3),'-r','displayname','Fitted outer fiber contour')
    legend('show')
end

Width = max(outerNodes(1:end-1,2)) - min(outerNodes(1:end-1,2));
Height = max(outerNodes(1:end-1,3)) - min(outerNodes(1:end-1,3));
A = geomOuter(1) - geomInner(1);
Iyy = inerOuter(4) - inerInner(4);

