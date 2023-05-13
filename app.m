clc, clearvars, close all

% Input parameters
% Let user choose image from which to extract watermark
[filename, filepath] = uigetfile('*.*', 'Select the cover image');
    path = fullfile(filepath, filename);
    img = im2double(imread(path));
[filename, filepath] = uigetfile('*.*', 'Select the watermark image');
    path = fullfile(filepath, filename);
    watermark = im2double(imread(path));

key = 394;

% Watermark embedding and extraction
y = embed(img, watermark, key);

% Evaluation metrics
MSE = immse(y, img);
PSNR = psnr(y, img);

% Display original image and watermarked image
figure;
sgtitle('Watermark Embedding')
subplot(1,3,1), imshow(img), title('Original image')
subplot(1,3,2), imshow(watermark,[]), title('Watermark')
subplot(1,3,3), imshow(y), title({['Watermarked image'], ...
                                  ['PSNR: ', num2str(PSNR, '%.2f'), ' dB'],...
                                  ['MSE: ', num2str(MSE, '%.5f')]})
% Download watermarked image
imwrite(y, 'watermarked_image.jpg');

% Ask user if they want to extract watermark
choice = input('Do you want to extract the watermark from the watermarked image? (y/n)', 's');

if lower(choice) == 'y'
    % Let user choose image from which to extract watermark
    [filename, filepath] = uigetfile('*.*', 'Select image for watermark extraction');
    if filename ~= 0
        path = fullfile(filepath, filename);
        I = im2double(imread(path));
        W = extract(img, I, key);
        
        % Evaluation metrics
        MSE = immse(W, watermark);
        PSNR = psnr(W, watermark);
        
        % Display results
        figure;
        sgtitle('Watermark Extraction')
        subplot(1,2,1), imshow(y), title('Watermarked image')
        subplot(1,2,2), imshow(W), title('Extracted watermark')
        % Download watermarked image
        imwrite(W, 'Extracted_watermark.bmp');
    end
else
    disp('Watermark extraction not performed.')
end
