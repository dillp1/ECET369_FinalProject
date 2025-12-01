% Clear vars
clc;
clear;

[imgG1, good1, s1] = findBruises("./images/good1.jpg");
[imgG2, good2, s2] = findBruises("./images/good2.jpg");
[imgG3, good3, s3] = findBruises("./images/good3.jpg");
[imgG4, good4, s4] = findBruises("./images/good4.jpg");
[imgG5, good5, s5] = findBruises("./images/good5.jpg");

[imgB1, bruised1, s6] = findBruises("./images/bruised1.jpg");
[imgB2, bruised2, s7] = findBruises("./images/bruised2.jpg");
[imgB3, bruised3, s8] = findBruises("./images/bruised3.jpg");
[imgB4, bruised4, s9] = findBruises("./images/bruised4.jpg");
[imgB5, bruised5, s10] = findBruises("./images/bruised5.jpg");

% Display all original images with their bruising detection
figure();
subplot(1,2,1), imshow(imgG1); title('Original Color Image');
subplot(1,2,2), imshow(good1); title('Buising Detections');
figure();
subplot(1,2,1), imshow(imgG2); title('Original Color Image');
subplot(1,2,2), imshow(good2); title('Buising Detections');
figure();
subplot(1,2,1), imshow(imgG3); title('Original Color Image');
subplot(1,2,2), imshow(good3); title('Buising Detections');
figure();
subplot(1,2,1), imshow(imgG4); title('Original Color Image');
subplot(1,2,2), imshow(good4); title('Buising Detections');

figure();
subplot(1,2,1), imshow(imgB1); title('Original Color Image');
subplot(1,2,2), imshow(bruised1); title('Buising Detections');
figure();
subplot(1,2,1), imshow(imgB2); title('Original Color Image');
subplot(1,2,2), imshow(bruised2); title('Buising Detections');
figure();
subplot(1,2,1), imshow(imgB3); title('Original Color Image');
subplot(1,2,2), imshow(bruised3); title('Buising Detections');
figure();
subplot(1,2,1), imshow(imgB4); title('Original Color Image');
subplot(1,2,2), imshow(bruised4); title('Buising Detections');

% Display all masked images and their decisions
figure();
subplot(2,5,1), imshow(good1); title('good1'); xlabel(s1)
subplot(2,5,2), imshow(good2); title('good2'); xlabel(s2)
subplot(2,5,3), imshow(good3); title('good3'); xlabel(s3)
subplot(2,5,4), imshow(good4); title('good4'); xlabel(s4)
subplot(2,5,5), imshow(good5); title('good5'); xlabel(s5)

subplot(2,5,6), imshow(bruised1); title('bruised1'); xlabel(s6)
subplot(2,5,7), imshow(bruised2); title('bruised2'); xlabel(s7)
subplot(2,5,8), imshow(bruised3); title('bruised3'); xlabel(s8)
subplot(2,5,9), imshow(bruised4); title('bruised4'); xlabel(s9)
subplot(2,5,10), imshow(bruised5); title('bruised5'); xlabel(s10)


function [bananaImage, overlay, decision] = findBruises(filename)
% Read the image
bananaImage = imread(filename);
% Display
%figure();
%imshow(bananaImage), title('Bruised Banana Image jpg');

% Get the banana mask from Thresholder App
[BW_banana, maskedRGB] = createMask(bananaImage);
% Clean up the mask
BW_banana = bwareaopen(BW_banana, 500);
BW_banana = imfill(BW_banana, 'holes');
% Keep only the largest region (the banana)
BW_banana = bwareafilt(BW_banana, 1);
% Display
%figure();
%subplot(1,2,1), imshow(maskedRGB), title('Masked Banana');
%subplot(1,2,2), imshow(BW_banana), title('Banana Mask');

% Detect the bounding box of the banana
props = regionprops(BW_banana, 'BoundingBox');
bbox = props(1).BoundingBox;

% Crop the the RGB and mask images
croppedRGB = imcrop(bananaImage, bbox);
croppedMask = imcrop(BW_banana, bbox);

% Convert to HSV
croppedHSV = rgb2hsv(croppedRGB);

% Pull the HSV channels
H = croppedHSV(:,:,1);
S = croppedHSV(:,:,2);
V = croppedHSV(:,:,3);

% Set threshold for how dark a bruise is
darkThresh = 0.6;
% Set a saturation threshold
satMin = 0.3;

% Approximate a yellow hue span
yellowLow  = 0.10;
yellowHigh = 0.18;

% Detect "good" yellow pixels
goodYellow = (H >= yellowLow) & (H <= yellowHigh) & (S > 0.4) & (V > 0.5);

% Create a bruise mask out of non-good pixels
bruiseMask = croppedMask & (V < darkThresh) & (S > satMin) & ~goodYellow;

% Display
%figure;
%imshow(bruiseMask), title('Bruise Mask (Cropped)');

% Find the counts of yellow pixels and bruise pixels
N_banana = nnz(croppedMask);
N_bruise = nnz(bruiseMask);
bruiseRatio = N_bruise / N_banana;

% Make a decision
if bruiseRatio > 0.3
    decision = 'bruised';
    fprintf('%s: The banana is bruised.\n', filename);
else
    decision = 'OK';
    fprintf('%s: The banana is not bruised.\n', filename);
end

% Display Final Image
%figure();
%subplot(2,3,1), imshow(bananaImage), title('Bruised Banana Image jpg');
%subplot(2,3,2), imshow(maskedRGB), title('Masked Banana');
%subplot(2,3,3), imshow(BW_banana), title('Banana Mask');
%subplot(2,3,4), imshow(bruiseMask), title('Bruise Mask (Cropped)'); 
overlay = croppedRGB;
overlay(repmat(bruiseMask,[1 1 3])) = 255;
%subplot(2,3,5), imshow(overlay); title('Detected Bruises (Cleaned & Cropped)');

end

% === FUNCTIONS ===

function [BW,maskedRGBImage] = createMask(RGB)
%createMask  Threshold RGB image using auto-generated code from colorThresholder app.
%  [BW,MASKEDRGBIMAGE] = createMask(RGB) thresholds image RGB using
%  auto-generated code from the colorThresholder app. The colorspace and
%  range for each channel of the colorspace were set within the app. The
%  segmentation mask is returned in BW, and a composite of the mask and
%  original RGB images is returned in maskedRGBImage.

% Auto-generated by colorThresholder app on 28-Nov-2025
%------------------------------------------------------


% Convert RGB image to chosen color space
I = rgb2hsv(RGB);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.000;
channel1Max = 1.000;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.487;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.000;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

end
