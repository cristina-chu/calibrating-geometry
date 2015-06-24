%Cristina Chu

%PS3
%Part 1.1 - Least Square Function

%---Reading points from file
fileID = fopen('pts2d-norm-pic_a.txt');
normPts2d = textscan(fileID, '%f %f');
fclose(fileID);

fileID = fopen('pts3d-norm.txt');
normPts3d = textscan(fileID, '%f %f %f');
fclose(fileID);

%---Dividing coordinates of points into their own matrices
%3d-points:
x = normPts3d{1};
y = normPts3d{2};
z = normPts3d{3};

%2d-points:
u = normPts2d{1};
v = normPts2d{2};

%one matrix and zero matrix
o = ones(size(x));
n = zeros(size(x));

%---Making the A matrix 
eq1 = [x y z o n n n n -u.*x -u.*y -u.*z -u];
eq2 = [n n n n x y z o -v.*x -v.*y -v.*z -v];

A = [eq1; eq2];

%---Using Singular Value Decomposition to get U,D,V
[U, D, V] = svd(A'*A);

%---Getting eigenvector of A'*A with smallest eigenvalue (mStar)
%Sol: last column of V
mStar = V(:,end);
m = reshape(mStar, 3, 4);   %getting actual m matrix


%---Calculating normalized 2D points using calculated m
points3d = [x y z];
newPts3d = [points3d'; ones(1,20)];
MP = m*newPts3d;

for i = 1:size(x)
    MP(1,i) = MP(1,i)/MP(3,i);
    MP(2,i) = MP(2,i)/MP(3,i);
    MP(3,i) = MP(3,i)/MP(3,i);
end

%Getting residual, last point projection and last point projection residual
points2d = [u v];
diff = points2d - MP(1:2, :)';

residual = diff.^2;

lastPtProj = MP(1:2, end);

lastPtProjResidual = sqrt(sum(residual(end,:)));

m
lastPtProj
lastPtProjResidual

