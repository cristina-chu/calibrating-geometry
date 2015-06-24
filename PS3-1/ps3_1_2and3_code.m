%Cristina Chu

%PS3
%Part 1.2 Overconstraining
%Part 1.3 Getting camera Center

%---Reading points from file
fileID = fopen('pts2d-pic_b.txt');
normPts2d = textscan(fileID, '%f %f');
fclose(fileID);

fileID = fopen('pts3d.txt');
normPts3d = textscan(fileID, '%f %f %f');
fclose(fileID);

%minresidual
minresidual = 1e100;

%---Will want to do set of size k = 8, 12 or 16
%Repeat all process 10 times for each size k
for k = [8,12,16]
    for t = 1:10
        %---Choose k train points and 4 test points 
        %index of points
        points = randperm(20, k+4);
        train = points(1:k);
        test = points(k+1:k+4);

        %3d train points
        x = normPts3d{1}(train);
        y = normPts3d{2}(train);
        z = normPts3d{3}(train);

        %3d test points
        xt = normPts3d{1}(test);
        yt = normPts3d{2}(test);
        zt = normPts3d{3}(test);

        %2d train points
        u = normPts2d{1}(train);
        v = normPts2d{2}(train);

        %2d test points
        ut = normPts2d{1}(test);
        vt = normPts2d{2}(test);

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
        points3d = [xt yt zt];
        newPts3d = [points3d'; ones(1,4)];
        MP = m*newPts3d;

        for i = 1:4
            MP(1,i) = MP(1,i)/MP(3,i);
            MP(2,i) = MP(2,i)/MP(3,i);
            MP(3,i) = MP(3,i)/MP(3,i);
        end

        %---Dealing with residuals and best/min M
        points2d = [ut vt];
        diff = points2d - MP(1:2, :)';
        residual = diff.^2;
        
        residual = mean(residual(:));
        
        sumK(t) = residual;
        
        if (residual < minresidual)
            residual = minresidual;
            minM = m;
        end
        
    end
    
    %--Showing results
    k
    avgResiduals = sumK'
    bestM = minM
    
    %Part 1.3 
    %Getting camera Center
    %q = bestM(:,1:3);
    %m4 = bestM(:,4);
    
    %cameraCenter = -inv(q)*m4
    
end

