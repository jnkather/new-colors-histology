% JN Kather 2015, for license see separate file

% project points on a plane in 3D
% N = normal, point = Point on Plane

function pointsOut = projectOnPlane(pointsIn, normal, point) 
    pointsIn = double(pointsIn);   % prepare point set
    [m,n] = size(pointsIn);        % read size
    normal = normal/norm(normal);  % normalize the normal vector
    
    % perform the actual projection
    proM = normal.'*normal;          
    pointsOut = pointsIn*(eye(3)-proM)+repmat(point*proM,m,1);
end