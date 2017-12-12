function [points, DT] = pointRepel(inputPoints)

plot(inputPoints(:,1),inputPoints(:,2),'r+')

DT = delaunayTriangulation(inputPoints);

triplot(DT)
hold on
IC = incenter(DT);
plot(IC(:,1),IC(:,2),'r+');

%axis([-0.2 1.2 -0.2 1.2])

Size = size(DT.ConnectivityList);


MeanDistance = 1/Size(1);


 Pnew=inputPoints;


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

 points = Pnew;
 
 
hold on
triplot(DT,'r')
     
%c = minBoundingBox(P')

%hold on,   plot(c(1,[1:end 1]),c(2,[1:end 1]),'r')


end
