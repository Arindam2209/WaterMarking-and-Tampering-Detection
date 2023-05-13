% Load the tampered image and the original watermark
tampered_img = imread('Extracted_watermark.bmp');
original_watermark = imread('watermark.bmp');

% Define the sub-block size
sub_block_size = 8;

% Define the similarity threshold
similarity_threshold = 0.9;

% Define the distortion threshold
distortion_threshold = 0.1;

% Initialize the counters
cat1_counter = 0;
cat2_counter = 0;
similarity_counter = 0;

% Loop through the sub-blocks
for i = 1:sub_block_size:size(tampered_img,1)
    for j = 1:sub_block_size:size(tampered_img,2)
        % Extract the sub-blocks
        sub_block_tampered = tampered_img(i:i+sub_block_size-1, j:j+sub_block_size-1, :);
        sub_block_original = original_watermark(i:i+sub_block_size-1, j:j+sub_block_size-1, :);
        
        % Compute the difference between the similar color pixel byte elements
        diff_counter = sum(sum(sum(abs(sub_block_tampered - sub_block_original))));
        
        % Compute the average value of all the sub-block elements
        avg_tampered = mean(sub_block_tampered(:));
        avg_original = mean(sub_block_original(:));
        
        % Update the counters based on the thresholds
        if diff_counter < 8
            cat1_counter = cat1_counter + 1;
        elseif diff_counter < 16
            cat2_counter = cat2_counter + 1;
        end
        
        if abs(avg_tampered - avg_original) < similarity_threshold
            similarity_counter = similarity_counter + 1;
        end
    end
end

% Compute the ratios
cat1_ratio = cat1_counter / (size(tampered_img,1) * size(tampered_img,2) / sub_block_size^2);
cat2_ratio = cat2_counter / (size(tampered_img,1) * size(tampered_img,2) / sub_block_size^2);
similarity_ratio = similarity_counter / (size(tampered_img,1) * size(tampered_img,2) / sub_block_size^2);

% Compute the distortion aspect of the extracted watermark image
if similarity_ratio >= similarity_threshold && cat1_ratio + cat2_ratio >= distortion_threshold
    disp('The watermark has been tampered with.');
else
    disp('The watermark is intact.');
end
