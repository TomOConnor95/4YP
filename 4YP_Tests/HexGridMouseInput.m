close all

nRows = 5;
nColumns = 5;
gridLength = 5;

grid = HexGrid(nRows, nColumns, gridLength);
gridEdge = HexGridEdge(nRows, nColumns, gridLength);

plot(grid(:,1),grid(:,2),'r+')
axis equal
hold on
plot(gridEdge(:,1),gridEdge(:,2),'b+')
axis equal




%%
figure(2)
dt = delaunayTriangulation([grid(:,1),grid(:,2)],gridEdge); %,gridEdge
hold on
triplot(dt)
% 
% %create structure copying dt to allow edits
% dts.Points = dt.Points;
% dts.ConnectivityList = dt.ConnectivityList;
% 
% % remove any triangles with vertical lines, i.e keep the edge jagged
% for i = length(dts.ConnectivityList):-1:1
%    
%     pointNos = dt.ConnectivityList(i,:);
%     points = dts.Points(pointNos,:);
%     vec1 = points(1,:)-points(2,:);
%     vec2 = points(1,:)-points(3,:);
%     vec3 = points(2,:)-points(3,:);
%     if dot(vec1,[1,0]) == 0 || dot(vec2,[1,0]) || dot(vec3,[1,0])
%         dts.ConnectivityList(i,:) = [];
%     end
% end
% 
% figure
% trisurf(dts.ConnectivityList, dts.Points);
%%

for i = 1:length(dt.ConnectivityList)
   
    pointNos = dt.ConnectivityList(i,:);
    points = dt.Points(pointNos,:);
    plot(points(:,1),points(:,2),'b+')
    
    pointSearch=1;
    while pointSearch == 1
       
        % generate random number pairs where sum <=1
        rand1 = rand;
        rand2 = rand;
        
        if rand1 + rand2 <= 1
        pointSearch = 0;
        end
    end
        % use these random numbers to generate points inside of triangles
    newPoint = points(1,:) + rand1*(points(2,:) - points(1,:)) + rand2*(points(3,:) - points(1,:));
    
    plot(newPoint(1),newPoint(2),'r+')
    
end