
[v,c] = voronoi(points(:,1), points(:,2));
for i = 1:length(c)
if all(c{i}~=1)   % If at least one of the indices is 1,
% then it is an open region and we can't
% patch that.
patch(v(c{i},1),v(c{i},2),i); % use color i.
end
end