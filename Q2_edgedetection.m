clear;clc;

%create a background image with pixel size 250 by 250
backgroundImage = 60 * ones(250,250, 'uint8');
imshow(backgroundImage);

%totalRectangles represent the total number of rectangles to generate
totalRectangles = 40;     

%these values are important for ensuring that the generated rectangles
%fill up the backgroundImage
minx = 0; 
maxx = 50;  
miny = 0; 
maxy = 50;   

% randomly generate 4 values which will be used for the rectangle
% positioning
rectValues = 30 .* rand(totalRectangles, 4);

%randomly generate rgb colors
color = rand(250, 3);

%generate the rectangles with the position, facecolor, and edgecolor
%properties of rectangle
for index = 1:totalRectangles
    rectangle('Position', rectValues(index, :), 'FaceColor', color(index, :),'EdgeColor', color(index, :));
end

%used for positioning the generated rectangles in the center of the image
xlim([minx, maxx]);
ylim([miny, maxy]);

%captures the axis and gets the frame
F = getframe;
%returns the associated image data in a RGB image
RGB = frame2im(F);
%converts the image to grey-level
I = rgb2gray(RGB);

%shows the generated image
figure;
imshow(I);

%Question 2b

%creates the laplacian of gaussian filter
LG = fspecial('log',20,3);
%shows the 3d image of the filter with its colormap
figure;
surf(LG);
colorbar;

%Question 2c

%filters the image using the laplacian of gaussian filter and convolution
FI = conv2(I,LG,'same');

%shift the image along the horizontal direction
FI_x1 = circshift(FI,-1,2);
%shift the image along the vertical direction
FI_y1 = circshift(FI,-1,1);
%shift the image along the left and upwards diagonal direction
FI_x1y1lu = circshift(FI,[-1,-1]);
%shift the image along the right and downwards direction
FI_x1y1rd = circshift(FI,[1,1]);

% product of the filtered image and the horizontal shifted image
Px = FI.*FI_x1; 
% product of the filtered image and the vertical shifted image
Py = FI.*FI_y1; 
% product of the filtered image and the left-upwards diagonally shifted image
Pxylu = FI.*FI_x1y1lu;
% product of the filtered image and the right-down diagonally shifted image
Pxyrd = FI.*FI_x1y1rd;

%creates 4 arrays that carries all 1s with the image pixel size
IedgeX = ones(250,250,'int8');
IedgeY = ones(250,250,'int8');
IedgeXYlu= ones(250,250,'int8');
IedgeXYrd= ones(250,250,'int8');
%for all values in the product matrix that correspond with the Iedge'
%indices, if the product value is larger than zero, set the value in Iedge'
%to zero
IedgeX(Px>0) = 0;
IedgeY(Py>0) = 0;
IedgeXYlu(Pxylu>0)= 0;
IedgeXYrd(Pxyrd>0)= 0;

%using bitwise or operator, merge the images to obtain a matrix
%representing the zero crossing in 4 directions
mergeFirst = bitor(IedgeX, IedgeY);
mergeSecond = bitor(IedgeXYlu, IedgeXYrd);
finalMerge = bitor(mergeFirst, mergeSecond);

%show the binary image containing all zero crossings
figure;
imagesc(finalMerge);
colormap gray


%Question 2d

%create the noise matrix use randn
noiseMatrix = randn(250);
%obtain the 1/10 values for the standard deviation of image instensities
deviation = 0.1.*(std2(I));
noiseMatrix = noiseMatrix.*deviation;
%create the image with noise
imageWithNoise = uint8(noiseMatrix) + I;

%shows the image with noise
FINoise = conv2(imageWithNoise,LG,'same');
figure;
imshow(FINoise);

%shift the image along the horizontal, vertical, left-upwards diagonal,
%right-downwards diagonal directions
FINoise_x1 = circshift(FINoise,-1,2);
FINoise_y1 = circshift(FINoise,-1,1);
FINoise_x1y1lu = circshift(FINoise,[-1,-1]);
FINoise_x1y1rd = circshift(FINoise,[1,1]);

%form the product matrices along the horizontal, vertical, left-upwards diagonal,
%right-downwards diagonal directions
PxNoise = FINoise.*FINoise_x1;
PyNoise = FINoise.*FINoise_y1;
PxyluNoise = FINoise.*FINoise_x1y1lu;
PxyrdNoise = FINoise.*FINoise_x1y1rd;

%creates 4 arrays that carries all 1s with the image pixel size
IedgeXNoise = ones(250,250,'int8');
IedgeYNoise = ones(250,250,'int8');
IedgeXYluNoise= ones(250,250,'int8');
IedgeXYrdNoise= ones(250,250,'int8');
%for all values in the product matrix that correspond with the IedgeNoise'
%indices, if the product value is larger than zero, set the value in IedgeNoise'
%to zero
IedgeXNoise(PxNoise>0) = 0;
IedgeYNoise(PyNoise>0) = 0;
IedgeXYluNoise(PxyluNoise>0)= 0;
IedgeXYrdNoise(PxyrdNoise>0)= 0;

%using bitwise or operator, merge the images to obtain a matrix
%representing the zero crossing in 4 directions
mergeFirstNoise = bitor(IedgeXNoise, IedgeYNoise);
mergeSecondNoise = bitor(IedgeXYluNoise, IedgeXYrdNoise);
finalMergeNoise = bitor(mergeFirstNoise, mergeSecondNoise);

%show the binary image containing all zero crossings
figure;
imagesc(finalMergeNoise);
colormap gray

%Question 2e

LG = fspecial('log',40,6);

%shows the image with noise
FINoise = conv2(imageWithNoise,LG,'same');

%shift the image along the horizontal, vertical, left-upwards diagonal,
%right-downwards diagonal directions
FINoise_x1 = circshift(FINoise,-1,2);
FINoise_y1 = circshift(FINoise,-1,1);
FINoise_x1y1lu = circshift(FINoise,[-1,-1]);
FINoise_x1y1rd = circshift(FINoise,[1,1]);

%form the product matrices along the horizontal, vertical, left-upwards diagonal,
%right-downwards diagonal directions
PxNoise = FINoise.*FINoise_x1;
PyNoise = FINoise.*FINoise_y1;
PxyluNoise = FINoise.*FINoise_x1y1lu;
PxyrdNoise = FINoise.*FINoise_x1y1rd;

%creates 4 arrays that carries all 1s with the image pixel size
IedgeXNoise = ones(250,250,'int8');
IedgeYNoise = ones(250,250,'int8');
IedgeXYluNoise= ones(250,250,'int8');
IedgeXYrdNoise= ones(250,250,'int8');
%for all values in the product matrix that correspond with the IedgeNoise'
%indices, if the product value is larger than zero, set the value in IedgeNoise'
%to zero
IedgeXNoise(PxNoise>0) = 0;
IedgeYNoise(PyNoise>0) = 0;
IedgeXYluNoise(PxyluNoise>0)= 0;
IedgeXYrdNoise(PxyrdNoise>0)= 0;

%using bitwise or operator, merge the images to obtain a matrix
%representing the zero crossing in 4 directions
mergeFirstNoise = bitor(IedgeXNoise, IedgeYNoise);
mergeSecondNoise = bitor(IedgeXYluNoise, IedgeXYrdNoise);
finalMergeNoise = bitor(mergeFirstNoise, mergeSecondNoise);

%show the binary image containing all zero crossings
figure;
imagesc(finalMergeNoise);
colormap gray


