function [matrixLL,matrixLH,matrixHL,matrixHH] = Decompose(inputIMG)
%DECOMPOSE 此处显示有关此函数的摘要
%   此处显示详细说明

h0 = [0.3415 0.5915 0.1585 -0.0915];
h1 = [0.0915 0.1585 -0.5915 0.3415];
g0 = [-0.0915 0.1585 0.5915 0.3415];
g1 = [0.3415 -0.5915 0.1585 0.0915];
[N,C] = size(inputIMG);
%% Diagonal HH
matrixH =[];
% 行操作
for i = 1 : N
    xRow = inputIMG(i,:);
    rowsHp=conv(xRow,h1);
    rowsHpNew = downsample(rowsHp,2);
    matrixH = [matrixH;rowsHpNew];
end
% matrixH
% 列操作
matrixHH =[];
[r,c] = size(matrixH);
for i = 1 : c
    xcol = matrixH(:,i);
    colsHp=conv(xcol',h1);
    colsHpNew = downsample(colsHp,2);
    matrixHH = [matrixHH;colsHpNew];
end

matrixHH= matrixHH';
% normMatrixHH = normalize(matrixHH);
% imshow(uint8(normMatrixHH));
% title('H1 H1 image')

% --------归一化另一种实现--------
% FlattenedData = matrixHH(:)'; % 展开矩阵为一列，然后转置为一行。
% MappedFlattened = mapminmax(FlattenedData, 0, 255); % 归一化。
% MappedData = reshape(MappedFlattened, size(matrixHH)); % 还原为原始矩阵形式。此处不需转置回去，因为reshape恰好是按列重新排序
% --------归一化另一种实现--------
%% Vertical HL
matrixH =[];
% 行操作
for i = 1 : N
    xRow = inputIMG(i,:);
    rowsHp=conv(xRow,h1);
    rowsHpNew = downsample(rowsHp,2);
    matrixH = [matrixH;rowsHpNew];
end

% 列操作
matrixHL =[];
[r,c] = size(matrixH);
for i = 1 : c
    xcol = matrixH(:,i);
    colsLp=conv(xcol',h0);
    colsLpNew = downsample(colsLp,2);
    matrixHL = [matrixHL;colsLpNew];
end

matrixHL= matrixHL';
% normMatrixHL = normalize(matrixHL);
% imshow(uint8(normMatrixHL));
% title('H1 H0 image');
%% Horizontal LH
matrixL =[];
% 行操作
for i = 1 : N
    xRow = inputIMG(i,:);
    rowsLp=conv(xRow,h0);
    rowsLpNew = downsample(rowsLp,2);
    matrixL = [matrixL;rowsLpNew];
end
% matrixL
% 列操作
matrixLH =[];
[r,c] = size(matrixL);
for i = 1 : c
    xcol = matrixL(:,i);
    colsHp=conv(xcol',h1);
    colsHpNew = downsample(colsHp,2);
    matrixLH = [matrixLH;colsHpNew];
end

matrixLH= matrixLH';
% normMatrixLH = normalize(matrixLH);
% imshow(uint8(normMatrixLH));
% title('H0 H1 image');
%% Lowpass LL
matrixL =[];
% 行操作
for i = 1 : N
    xRow = inputIMG(i,:);
    rowsLp=conv(xRow,h0);
    rowsLpNew = downsample(rowsLp,2);
    matrixL = [matrixL;rowsLpNew];
end
% matrixL
% 列操作
matrixLL =[];
[r,c] = size(matrixL);
for i = 1 : c
    xcol = matrixL(:,i);
    colsLp = conv(xcol',h0);
    colsLpNew = downsample(colsLp,2);
    matrixLL = [matrixLL;colsLpNew];
end

matrixLL= matrixLL';
% normMatrixLL = normalize(matrixLL);
% imshow(uint8(normMatrixLL));
% title('H0 H0 image');
end

