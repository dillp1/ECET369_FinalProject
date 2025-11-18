% Clear vars
clc;
clear;

% Read in the image
k = imread("./images/banana_online.jpg");

% === PREPROCESSING ===

% Convert image to gray level image
k_gray = rgb2gray(k);

% Invert the gray level image
k_gray_invert = imcomplement(k_gray);

% Define the average filter
lb_avg_filter = fspecial('average');

% Apply the filter to the image
avg_clr_img = imfilter(k, lb_avg_filter);

% Convert the avg image to gray level
avg_gray = rgb2gray(avg_clr_img);

% === Pull Color Channels ===

% Extract color channels
k_red = k(:,:,1);
k_green = k(:,:,2);
k_blue = k(:,:,3);

% === Edge Detection ===

% Perform edge detection
edge_sobel = edge(k_gray_invert, "sobel");
edge_roberts = edge(k_gray_invert, "roberts");
edge_prewitt = edge(k_gray_invert, "prewitt");
edge_canny = edge(k_gray_invert, "canny");

% === Binarize using MATLAB commands === %

% Get the gray threshold
T = graythresh(avg_gray);

% Binarize the color image
binary_gray = imbinarize(avg_gray, T);

% === OUTPUTS ===

% Display the extracted color channels
figure;
subplot(2, 2, 1), imshow(k), title('Original Image');
subplot(2, 2, 2), imshow(k_red), title('Red Channel');
subplot(2, 2, 3), imshow(k_green), title('Green Channel');
subplot(2, 2, 4), imshow(k_blue), title('Blue Channel');

% Edge detected images
figure();
subplot(2, 2, 1), imshow(edge_sobel), title('Edge Detection (Sobel)');
subplot(2, 2, 2), imshow(edge_roberts), title('Edge Detection (Roberts)');
subplot(2, 2, 3), imshow(edge_prewitt), title('Edge Detection (Prewitt)');
subplot(2, 2, 4), imshow(edge_canny), title('Edge Detection (Canny)');

% Display binarized images
figure();
subplot(2, 2, 1), imshow(k), title('Original Color Image');
subplot(2, 2, 2), imshow(avg_clr_img), title('Color Average Filtered Image');
subplot(2, 2, 3), imshow(avg_gray), title('Averaged Gray Image');
subplot(2, 2, 4), imshow(binary_gray), title('Binarized Color Image');
