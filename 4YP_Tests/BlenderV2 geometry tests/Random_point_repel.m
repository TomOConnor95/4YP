%clear all
%close all
P = rand(100,2);


plot(P(:,1),P(:,2),'r+')

DT = delaunayTriangulation(P);

triplot(DT)
hold on
IC = incenter(DT);
plot(IC(:,1),IC(:,2),'r+');

%axis([-0.2 1.2 -0.2 1.2])

 Size = size(DT.ConnectivityList);
 
%  Distance = 0;
% for i = Size(1)
%     Triangle = P([DT.ConnectivityList(i,:)],:);
% Distance= Distance + ...
%             [sqrt((Triangle(1,1)-Triangle(2,1)).^2+(Triangle(1,2)-Triangle(2,2)).^2)
%             sqrt((Triangle(2,1)-Triangle(3,1)).^2+(Triangle(2,2)-Triangle(3,2)).^2)
%             sqrt((Triangle(3,1)-Triangle(1,1)).^2+(Triangle(3,2)-Triangle(1,2)).^2)];
% end


MeanDistance = 1/Size(1);


 Pnew=P;
 pause

 k1 = 0.015; % constant for spring mechanism
 k2 = 0.6;   % constant for inner circle mechanism
 
 for j = 1:100
     
     P=DT.Points;
     Pnew=P;
     for i = 1:Size(1)
         
         
         VertexDisplacements1 =TriangleDisplacements(P([DT.ConnectivityList(i,:)],:),IC(i,:),0.015);
         VertexDisplacements2 =TriangleDisplacements2(P([DT.ConnectivityList(i,:)],:),0.6,MeanDistance);
         
         Pnew([DT.ConnectivityList(i,:)],:)=P([DT.ConnectivityList(i,:)],:) +VertexDisplacements1+VertexDisplacements2;
         
     end
     clear DT
     clear IC
     DT = delaunayTriangulation(Pnew);
     IC = incenter(DT);
     DT.ConnectivityList;
     Size = size(DT.ConnectivityList);
    
     triplot(DT,'r')
    hold off
     pause(0.01)
     triplot(DT,'g')
  
     voronoi(P(:,1),P(:,2)) 
     hold on
   
 end

hold on
triplot(DT,'r')
     
c = minBoundingBox(P');
hold on,   plot(c(1,[1:end 1]),c(2,[1:end 1]),'r')
%  
%   
%   IC = incenter(DT);
%   plot(IC(:,1),IC(:,2),'b+');
% 
%  
%   
%   P= IC;
%   hold off
%   plot(IC(:,1),IC(:,2),'b+');
%   DT = delaunayTriangulation(P);
% triplot(DT)
% hold on
% IC = incenter(DT);
% plot(IC(:,1),IC(:,2),'r+');

% 


% 
% Distances1= [sqrt((Triangle1(1,1)-Triangle1(2,1)).^2+(Triangle1(1,2)-Triangle1(2,2)).^2)
%             sqrt((Triangle1(2,1)-Triangle1(3,1)).^2+(Triangle1(2,2)-Triangle1(3,2)).^2)
%             sqrt((Triangle1(3,1)-Triangle1(1,1)).^2+(Triangle1(3,2)-Triangle1(1,2)).^2)]
% Displacement1 = 0.02*1./Distances1.^2



            
% 
% pause 
% DT = delaunayTriangulation(P);
% triplot(DT,'g')