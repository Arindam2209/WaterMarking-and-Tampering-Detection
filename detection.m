% Input parameters
% Let user choose image from which to extract watermark
[filename, filepath] = uigetfile('*.*', 'Select the Original watermark image');
    path = fullfile(filepath, filename);
    originalImage = im2double(imread(path));
[filename, filepath] = uigetfile('*.*', 'Select the Extracted watermark image');
    path = fullfile(filepath, filename);
    extractedImage = im2double(imread(path));

threshold = 1;
cat1 = 0;
cat2 = 0;

for i = 1:size(originalImage, 1)-1
    for j = 1:size(originalImage, 2)-1
        a = originalImage(i, j);
        c = originalImage(i + 1, j);
        
        if abs(a - c) < threshold
            cat1 = cat1 + 1;
        end
    end
end     

for k = 1:size(extractedImage, 1)-1
    for l = 1:size(extractedImage, 2)-1  
        b = extractedImage(k, l);
        d = extractedImage(k + 1, l);
        
        if abs(b - d) < threshold
            cat2 = cat2 + 1;
        end
    end
end

disp('cat:');
disp(['cat1: ' num2str(cat1)]);
disp(['cat2: ' num2str(cat2)]);

% Calculate cat1 for the original image
cat1Original = varcat1(originalImage);

% Calculate cat1 for the extracted image
cat1Extracted = varcat1(extractedImage);

% Calculate cat2 for the original image
cat2Original = varcat2(originalImage);

% Calculate cat2 for the extracted image
cat2Extracted = varcat2(extractedImage);

% Display the results
disp('Original Image:');
disp(['cat1: ' num2str(cat1Original)]);
disp(['cat2: ' num2str(cat2Original)]);

disp('Extracted Image:');
disp(['cat1: ' num2str(cat1Extracted)]);
disp(['cat2: ' num2str(cat2Extracted)]);

% Evaluation metrics
MSE = immse(extractedImage, originalImage);
PSNR = psnr(extractedImage, originalImage);
SSIM = ssim(extractedImage, originalImage);

% Convert images to grayscale if necessary
if size(extractedImage, 3) > 1
    M = rgb2gray(extractedImage);
else
    M = extractedImage;
end

if size(originalImage, 3) > 1
    N = rgb2gray(originalImage);
else
    N = originalImage;
end

% Calculate cross-correlation
CC = corr2(M, N);

X1 = mean(originalImage(:));
X2 = mean(extractedImage(:));


similarity = abs(X1 - X2);
distortionThreshold = 0.1;
ratio=cat1/cat2;

ratio1 = cat1 / ((size(originalImage, 1)-1) * (size(originalImage, 2)-1));
ratio2 = cat2 / ((size(originalImage, 1)-1) * (size(originalImage, 2)-1));


% Perform tampering detection
difference = imabsdiff(originalImage, extractedImage);
tamperedPixels = sum(difference(:) > 0);

% Calculate noise percentage
totalPixels = numel(originalImage);
noisePercentage = (tamperedPixels / totalPixels) * 100;

% Calculate tampering percentage
tamperingPercentage = (tamperedPixels / numel(extractedImage)) * 100;

% Display results
fprintf('Noise Percentage: %.2f%%\n', noisePercentage);
fprintf('Tampering Percentage: %.2f%%\n', tamperingPercentage);

% Determine if tampering or noise is detected
if tamperingPercentage > 18.5
    tamperingResult = 'Tampering detected.';
    noiseResult = 'Noise detected';
elseif noisePercentage > 0
    tamperingResult = 'No Tampering detected';
    noiseResult = 'Noise detected.';
else
    tamperingResult = 'No tampering or noise detected.';
    noiseResult = '';
end

figure('Name', 'Tampering Detection');

% Subplot 1
subplot(4,2,1);
imshow(originalImage);
title('Original Watermark');

% Subplot 2
subplot(4,2,2);
imshow(extractedImage);
subtitle = {['Extracted Watermark', ...
             ' (PSNR: ', num2str(PSNR, '%.2f'), ' dB)', ...
             ' [CC: ', num2str(CC, '%.5f]')]};
title(subtitle);

% Plotting the first set of subplots
x = 1:2;  % x-axis values
y1 = [cat1 cat2];  % y-axis values for cat1 and cat2
y2 = [X1 X2];  % y-axis values for X1 and X2

subplot(4,2,3);
bar(x, y1);
xlabel('Category');
ylabel('Count');
title('Comparison of cat1 and cat2');
set(gca, 'XTickLabel', {'cat1', 'cat2'});

subplot(4,2,4);
bar(x, y2);
xlabel('Category');
ylabel('Count');
title('Comparison of X1 and X2');
set(gca, 'XTickLabel', {'X1', 'X2'});

% Hold on to merge with the second set of subplots
hold on;

% Plotting the second set of subplots
x = 1:2;  % x-axis values
y1 = [cat1Original cat1Extracted];  % y-axis values for cat1 and cat2
y2 = [cat2Original cat2Extracted];  % y-axis values for X1 and X2

subplot(4,2,5);
bar(x, y1);
xlabel('Category 1');
ylabel('Count');
title('Comparison of category 1');
set(gca, 'XTickLabel', {'cat1Original', 'cat1Extracted'});

subplot(4,2,6);
bar(x, y2);
xlabel('Category 2');
ylabel('Count');
title('Comparison of category 2');
set(gca, 'XTickLabel', {'cat2Original', 'cat2Extracted'});

% Create a new subplot for the result display
subplot(4,2,7:8); % Adjust the position and size as needed
% Add text annotations to the result display
text(0.5, 0.9, sprintf('Noise Percentage: %.2f%%', noisePercentage), 'FontSize', 12, 'HorizontalAlignment', 'center');
%text(0.5, 0.6, sprintf('Tampering Percentage: %.2f%%', tamperingPercentage), 'FontSize', 12, 'HorizontalAlignment', 'center');
text(0.5, 0.6, tamperingResult, 'FontSize', 12, 'HorizontalAlignment', 'center');
text(0.5, 0.3, noiseResult, 'FontSize', 12, 'HorizontalAlignment', 'center');

hold off;

% Determine if tampering or noise is detected
if tamperingPercentage > 18.5
    disp('Tampering detected.');
elseif noisePercentage > 0
    disp('Noise detected but No Tampering detected');
else
    disp('No tampering or noise detected.');
end


% Function to calculate cat1 for an image
function cat1 = varcat1(M)
    cat1 = 0;
    for i = 1:2:32
        for j = 1:2:32
            g = M(i, j);
            l = M(i+1, j);
            if abs(g - l) < 1
                cat1 = cat1 + 1;
            end
        end
    end
end

% Function to calculate cat2 for an image
function cat2 = varcat2(M)
    cat2 = 0;
    for i = 1:2:32
        for j = 2:2:32
            p = M(i, j);
            q = M(i+1, j);
            if abs(p - q) < 1
                cat2 = cat2 + 1;
            end
        end
    end
end
