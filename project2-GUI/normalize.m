function outputMatrix = normalize(matrix)
minV = 0;
maxV = 255;
xmax = max(max(matrix));% return max value in matrix
xmin = min(min(matrix));
% normalize and drop the decimal number
outputMatrix = round((maxV-minV)*(matrix-xmin)/(xmax-xmin) + minV); 
end

