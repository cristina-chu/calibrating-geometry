%Cristina Chu 

%PS3
%Part 2.3 - Estimate epilolar line

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

%---Getting epipolar lines
la = F*[uB vB ones(size(uB))]';
lb = F*[uA vA ones(size(uA))]';

for i = 1:size(la,2);
   la(:,i)=la(:,i)./la(3,i); 
   lb(:,i)=lb(:,i)./lb(3,i); 
end

%---Plotting lines on images
%Reading Images
imgA = imread('pic_a.jpg');
imgB = imread('pic_b.jpg');


%-Lines on imageA
[maxy, maxx] = size(imgA);
left=cross([1,1,1],[1,maxy,1]);
lright=cross([maxx,1,1],[maxx,maxy,1]);


%Drawing Epipolar lines on image a corresp to points in image b
imshow(imgA);
hold on;

picA=[uA vA ones(20,1)];
picB=[uB vB ones(20,1)];
line_l=left;
line_r=lright;


for i = 1:length(picB)
    l = F'*picB(i, :)'; 
    l = l/l(end);
    
    pleft = cross(l, left);
    pleft = pleft/pleft(end);
    
    pright = cross(l, lright);
    pright = pright/pright(end);
    
    plot([pleft(1), pright(1)], [pleft(2), pright(2)]);
end

