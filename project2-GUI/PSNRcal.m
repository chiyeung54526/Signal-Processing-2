function PSNR = PSNRcal(sourceIMG,encodedIMG,q)
%PSNRCAL calculate PSNR value through formula
%  sourceIMG: source image
%  encodedIMG: compressed image 
%  q: pixel value of source image
%  
[M,N] = size(sourceIMG);
sumTemp = 0;
for i = 1:M
    for j = 1:N
        temp = double((sourceIMG(i,j) - encodedIMG(i,j))^2);
        sumTemp = temp + sumTemp;
    end
end
MSE = sumTemp / (M*N);
% PSNR value in dB
PSNR = 10 * log10(((2^q - 1)^2) / MSE);

end

