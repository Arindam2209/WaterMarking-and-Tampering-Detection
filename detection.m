originalImage = imread('watermark.bmp');
extractedImage = imread('Extracted_watermark.bmp');

threshold = 8;
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
        

for i = 1:size(extractedImage, 1)-1
    for j = 1:size(extractedImage, 2)-1  
        b = extractedImage(i, j);
        d = extractedImage(i + 1, j);
        
        if abs(b - d) < threshold
            cat2 = cat2 + 1;
        end
    end
end

X1 = mean(originalImage(:));
X2 = mean(extractedImage(:));

variance1 = customVar(originalImage(:));
variance2 = customVar(extractedImage(:));

similarity = abs(X1 - X2);
distortionThreshold = 10;

ratio1 = cat1 / ((size(originalImage, 1)-1) * (size(originalImage, 2)-1));
ratio2 = cat2 / ((size(originalImage, 1)-1) * (size(originalImage, 2)-1));

if ratio1 > 0.5 || ratio2 > 0.5 || similarity > distortionThreshold || abs(variance1 - variance2) > distortionThreshold
    disp('Watermark tampering detected');
else
    disp('No watermark tampering detected');
end

function variance = customVar(image)
    meanValue = mean(image(:));
    squaredDiff = (image - meanValue).^2;
    sumSquaredDiff = sum(squaredDiff(:));
    variance = sumSquaredDiff / (numel(image) - 1);
end
