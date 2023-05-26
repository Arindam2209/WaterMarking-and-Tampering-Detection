clc, clearvars, close all

% Input parameters
% Let user choose image from which to extract watermark
[filename, filepath] = uigetfile('*.*', 'Select the cover image');
    path = fullfile(filepath, filename);
    img = im2double(imread(path));
    %img = im2uint8(img);

[filename, filepath] = uigetfile('*.*', 'Select the watermark image');
    path = fullfile(filepath, filename);
    watermark = im2double(imread(path));
    %watermark = im2uint8(watermark);

key = 394;

% Watermark embedding and extraction
y = embed(img, watermark, key);

% Evaluation metrics
MSE = immse(y, img);
PSNR = psnr(y, img);
SSIM = ssim(y, img);

% Convert images to grayscale if necessary
if size(y, 3) > 1
    M = rgb2gray(y);
end

if size(img, 3) > 1
    N = rgb2gray(img);
end

% Calculate cross-correlation
CC = corr2(M, N);

% Display original image and watermarked image
figure;
sgtitle('Watermark Embedding')
subplot(1,3,1), imshow(img), title('Original image')
subplot(1,3,2), imshow(watermark,[]), title('Watermark')
subplot(1,3,3), imshow(y), title({'Watermarked image', ...
                                  ['MSE: ', num2str(MSE, '%.10f')],...
                                  ['PSNR: ', num2str(PSNR, '%.10f'), ' dB'],...
                                  ['SSI: ', num2str(SSIM,'%.10f')],...
                                  ['CC: ', num2str(CC,'%.10f')]})


% Download watermarked image
imwrite(y, 'watermarked_image.jpg');


