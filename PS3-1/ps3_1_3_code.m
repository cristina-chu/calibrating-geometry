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


%---Calculating camera center
q = m(:,1:3);
m4 = m(:,4);
    
cameraCenter = -inv(q)*m4
