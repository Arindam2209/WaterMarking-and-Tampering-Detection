clc, clearvars, close all
    % Let user choose image from which to extract watermark
    [filename, filepath] = uigetfile('*.*', 'Select the cover image');
    path = fullfile(filepath, filename);
    img = im2double(imread(path));
    [filename, filepath] = uigetfile('*.*', 'Select the Stego image for watermark extraction');
    if filename ~= 0
        path = fullfile(filepath, filename);
        I = im2double(imread(path));

        key = 394;
        W = extract(img, I, key);
        
        % Evaluation metrics
        %MSE = immse(W, watermark);
        %PSNR = psnr(W, watermark);
        %SSIM = ssim(W, watermark);
        %CC = corr2(W, watermark);
        
        % Display results
        figure;
        sgtitle('Watermark Extraction')
        subplot(1,2,1), imshow(I), title('Stego Image')
        subplot(1,2,2), imshow(W,[]), title({'Extracted watermark'})
        %subplot(1,2,2), imshow(W), title({'Extracted watermark', ...
                                  %['MSE: ', num2str(MSE, '%.5f')],...
                                  %['PSNR: ', num2str(PSNR, '%.2f'), ' dB'],...
                                  %['SSI: ', num2str(SSIM,'%.5f')],...
                                  %['CC: ', num2str(CC,'%.5f')]})


        % Download watermarked image
        imwrite(W, 'Extracted_watermark.bmp');
    end
