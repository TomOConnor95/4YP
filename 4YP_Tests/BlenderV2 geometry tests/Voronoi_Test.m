clear all
close all
P = rand(50,2)
plot(P(:,1),P(:,2),'r+')


DT = delaunayTriangulation(P);
triplot(DT)
hold on
IC = incenter(DT);
plot(IC(:,1),IC(:,2),'r+');

axis([-0.2 1.2 -0.2 1.2])

 Size = size(DT.ConnectivityList);
 
 Pnew=P;
 pause
 for j = 1:100
     
     P=DT.Points;
     Pnew=P;
     for i = 1:Size(1)
         
         
         VertexDisplacements1 =TriangleDisplacements(P([DT.ConnectivityList(i,:)],:),IC(i,:),0.003);
         VertexDisplacements2 =TriangleDisplacements2(P([DT.ConnectivityList(i,:)],:),0.5);
         
         Pnew([DT.ConnectivityList(i,:)],:)=P([DT.ConnectivityList(i,:)],:) +VertexDisplacements1+VertexDisplacements2;
         
     end
     
     DT = delaunayTriangulation(Pnew);
     Size = size(DT.ConnectivityList)
     DT.ConnectivityList
     triplot(DT,'g')
     hold on
     voronoi(P(:,1),P(:,2)) 
     hold off
     pause(0.1)
     %triplot(DT,'g')
 end
hold on
triplot(DT,'r')
     

  
