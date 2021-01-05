
% code from the makeEdgeList.m file
% Read in the image, convert to grayscale, and detect edges.
% Creates an array edges where each row is    (x, y, cos theta, sin theta)   

clear;clc
im = imread("checkBlack.png");
im = imresize(rgb2gray(im), 0.5);

Iedges = edge(im,'canny');
%  imgradient computes the gradient magnitude and gradient direction
%  using the Sobel filter.  
[~,grad_dir]=imgradient(im);
%  imgradient defines the gradient direction as an angle in degrees
%  with a positive angle going (CCW) from positive x axis toward
%  negative y axis.   However, the (cos theta, sin theta) formulas from the lectures define theta
%  positive to mean from positive x axis to positive y axis.  For this
%  reason,  I will flip the grad_dir variable:
grad_dir = - grad_dir;

% imshow(Iedges)
%imagesc(Iedges);
% colormap gray;

%Now find all the edge locations, and add their orientations (cos theta,sin theta). 
%  row, col is  y,x
[row, col] = find(Iedges);
% Each edge is a 4-tuple:   (x, y, cos theta, sin theta)   

edges = [col, row, zeros(length(row),1), zeros(length(row),1) ];
for k = 1:length(row)
     edges(k,3) = cos(grad_dir(row(k),col(k))/180.0*pi);
     edges(k,4) = sin(grad_dir(row(k),col(k))/180.0*pi);
end

%dim_edge contains the number of edges formed
dim_edge = size(row);

%get the row and column of the image size
[Ny,Nx] = size(im);
%create a matrix of all zeros with the image size dimensions
Hr = zeros(Ny,Nx);

%loop condition to loop through all edges formed
for iedge = 1:dim_edge
    %if condition that checks if the line is closer to the vertical
    %direction than horizontal direction
    if (edges(iedge,4) > sqrt(2)/2)
     %looping through all x-coordinates of the points    
     for xi = 1:Nx
         % calculate the r-value using the formula: r = x*cos + y*sin
         r_0 = edges(iedge,1)*edges(iedge,3) + edges(iedge,2) * edges(iedge,4);
         % manipulate the above formula to isolate the y value
         yi = round((r_0 - xi*edges(iedge,3))/edges(iedge,4));
         % check if the y-coordinate value is within the boundary of the
         % image and if so, add a vote to the point
         if (yi>0 && yi<Ny)
             Hr(yi,xi) = Hr(yi,xi)+1;
         end
     end
    else
        %condition that the line is closer to the horizontal direction
        %than the vertical direction
        for yi = 1:Ny
            % calculate the r-value using the formula: r = x*cos + y*sin
            r_0 = edges(iedge,1)*edges(iedge,3) + edges(iedge,2) * edges(iedge,4);
            % manipulate the above formula to isolate the x value
            xi = round((r_0 - yi*edges(iedge,4))/edges(iedge,3));
            % check if the y-coordinate value is within the boundary of the
            % image and if so, add a vote to the point
            if (xi>0 && xi<Nx)
                Hr(yi,xi) = Hr(yi,xi)+1;
            end
        end
    end
end

%show the image with the votes and then set the image to grap
 figure;
 imagesc(1:Nx,1:Ny,Hr)
 %xlabel('x','FontSize',20);  ylabel('y','FontSize',20);
 colormap gray;
 %index and index y value pinpoints the 'peak' of the vanishing point by
 %finding the max values in the matrix with votes
%[indy,indx]=find(Hr==max(Hr(:)))