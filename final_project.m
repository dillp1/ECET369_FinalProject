% Clear vars
clc;
clear;

% Read in the image
k = imread("./images/banana_online.jpg");

% === PREPROCESSING ===

% Define the average filter
lb_avg_filter = fspecial('average');

% Apply the filter to the image
avg_clr_img = imfilter(k, lb_avg_filter);

% Convert the avg image to gray level
avg_gray = rgb2gray(avg_clr_img);

% === Binarize using MATLAB commands === %

% Get the gray threshold
T = graythresh(avg_gray);

% Binarize the color image
binary_gray = imbinarize(avg_gray, T);

% === OUTPUTS ===

% Display images
figure();
subplot(2, 2, 1), imshow(k), title('Original Color Image');
subplot(2, 2, 2), imshow(avg_clr_img), title('Color Average Filtered Image');
subplot(2, 2, 3), imshow(avg_gray), title('Averaged Gray Image');
subplot(2, 2, 4), imshow(binary_gray), title('Binarized Clor Image');
