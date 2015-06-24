%Cristina Chu 

%PS3
%Part 2.2 - Calculate F - modified SVD

%---Reading points from file
fileID = fopen('pts2d-pic_a.txt');
picA = textscan(fileID, '%f %f');
fclose(fileID);

fileID = fopen('pts2d-pic_b.txt');
picB = textscan(fileID, '%f %f');
fclose(fileID);

%---Dividing coordinates of points into their own matrices
%picA
uA = picA{1};
vA = picA{2};

%picB
uB = picB{1};
vB = picB{2};

%one matrixF
o = ones(size(uA));

%---Making the p matrix
p = [uA.*uB uA.*vB uA vA.*uB vA.*vB vA uB vB o];

%---Using Singular Value Decomposition to get U,D,V
[U, D, V] = svd(p'*p);

%---Getting F - eigenvector of p'*p with smallest eigenvalue
%Sol: last column of V
F = V(:,end);
F = reshape(F,3,3);

%---Modifying D (last singular value = 0)
[U D V] = svd(F);
D(end, end)=0;
F = U*D*V';

F




