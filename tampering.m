% Allow the user to select an image
[filename, filepath] = uigetfile('*.*', 'Select an image file');
if filename ~= 0
    % Load the selected image
    img = imread(fullfile(filepath, filename));

    % Display the original image
    figure;
    imshow(img);
    title('Original Image');

    % Allow the user to select a tampering option
    choice = menu('Select a tampering option:', ...
        'Gaussian noise', ...
        'Salt and pepper noise', ...
        'Motion blur', ...
        'Rotation', ...
        'Scaling');

    % Apply the selected tampering to the image
    switch choice
        case 1 % Gaussian noise
            sigma = input('Enter the standard deviation of the noise: ');
            tampered_img = imnoise(img, 'gaussian', 0, sigma^2);
            title_str = sprintf('Gaussian noise (\\sigma = %.2f)', sigma);
        case 2 % Salt and pepper noise
            density = input('Enter the noise density (0 to 1): ');
            tampered_img = imnoise(img, 'salt & pepper', density);
            title_str = sprintf('Salt and pepper noise (density = %.2f)', density);
        case 3 % Motion blur
            angle = input('Enter the blur angle (in degrees): ');
            len = input('Enter the blur length: ');
            h = fspecial('motion', len, angle);
            tampered_img = imfilter(img, h, 'replicate');
            title_str = sprintf('Motion blur (angle = %d, length = %d)', angle, len);
        case 4 % Rotation
            theta = input('Enter the rotation angle (in degrees): ');
            tampered_img = imrotate(img, theta, 'bilinear', 'crop');
            title_str = sprintf('Rotation (angle = %d)', theta);
        case 5 % Scaling
            scale_factor = input('Enter the scaling factor: ');
            tampered_img = imresize(img, scale_factor);
            title_str = sprintf('Scaling (factor = %.2f)', scale_factor);
    end

    % Display the tampered image
    figure;
    imshow(tampered_img);
    title(title_str);

    % Save the tampered image to disk
    imwrite(tampered_img, fullfile(filepath, sprintf('tampered_%s', filename)));

else
    disp('No file selected.');
end
