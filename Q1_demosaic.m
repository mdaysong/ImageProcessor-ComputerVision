clear;
clc;

%read the rgb image
original = imread('colorFruit.jpg');

%resize the original image to make it easier to work with
%To show the proper sampling for question 1a, I resized the original
%image with a scale value of 0.01
iSmall = imresize(original, 0.1);

%split the image into red, green and blue channels
r = iSmall(:,:,1); 
g = iSmall(:,:,2); 
b = iSmall(:,:,3); 

%create all-zero matrix
black = zeros(size(iSmall, 1), size(iSmall, 2), 'uint8');

%create red matrix where green and blue are replaced with black
red = cat(3, r, black, black);
%create green matrix where green and blue are replaced with black
green = cat(3, black, g, black);
%create blue matrix where green and blue are replaced with black
blue = cat(3, black, black, b);

%%take the dimensions of the small matrix
[rows, columns, numberOfColorChannels] = size(iSmall);

%allElements = rows * columns;
allElements = rows * columns;
%create a matrix with incrementing values
greenMatrixFilter = uint8(toeplitz(mod(1:rows,2), mod(1:columns,2)));
allOnes = uint8(ones(rows, columns));

redMatrixFilter = allOnes - greenMatrixFilter;
blueMatrixFilter = allOnes - greenMatrixFilter;
%get the red matrix of 0s and 1s
redMatrixFilter(1:2:rows, :) = 0;
%get the blue matrix of 0s and 1s
blueMatrixFilter(:,1:2:columns) = 0;

%get the Bayer pattern matrices
greenMatrix = green .* greenMatrixFilter;
redMatrix = red .* redMatrixFilter;
blueMatrix = blue .* blueMatrixFilter;

%this montage shows the filtered red image, filtered green image,
%filtered blue image and the original scaled image
figure
montage({redMatrix, greenMatrix, blueMatrix, iSmall});

%create the image filters for convolution
blueFilter = [0.25 0.5 0.25; 0.5 1 0.5; 0.25 0.5 0.25];
redFilter = [0.25 0.5 0.25; 0.5 1 0.5; 0.25 0.5 0.25];
greenFilter = [0 0.25 0; 0.25 1 0.25; 0 0.25 0];

%apply image convolution
greenInterpolationShift = conv2(greenFilter, greenMatrix(:,:,2));
blueInterpolationShift = conv2(blueFilter, blueMatrix(:,:,3));
redInterpolationShift = conv2(redFilter, redMatrix(:,:,1));

%delete the extra padding surrounding the image matrix
greenMatrix(:,:,2) = greenInterpolationShift(2:(end-1),2:(end-1));
redMatrix(:,:,1) = redInterpolationShift(2:(end-1),2:(end-1));
blueMatrix(:,:,3) = blueInterpolationShift(2:(end-1),2:(end-1));

%concatenate the averaged red, green and blue channels
finalMatrix = cat(3, redMatrix(:,:,1), greenMatrix(:,:,2), blueMatrix(:,:,3));

%this montage shows the interpolated red image, interpolated green image,
%interpolated blue image and the original scaled image
figure
montage({redMatrix, greenMatrix, blueMatrix, finalMatrix});














