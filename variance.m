function variance = variance(image)
    % Calculate the mean of the image
    meanValue = mean(image(:));

    % Calculate the squared differences between each pixel and the mean
    squaredDiff = (image - meanValue).^2;

    % Calculate the sum of squared differences
    sumSquaredDiff = sum(squaredDiff(:));

    % Divide the sum by the number of pixels minus 1 to get the variance
    variance = sumSquaredDiff / (numel(image) - 1);
end
