function matrix_y = Reconstruct(matrixLL,matrixLH,matrixHL,matrixHH)
%% RECONSTRUCT 此处显示有关此函数的摘要
%   此处显示详细说明

g0 = [-0.0915 0.1585 0.5915 0.3415];
g1 = [0.3415 -0.5915 0.1585 0.0915];
%% Reconstruction
% reconstruct HH
% diagonal 矩阵行操作
matrixRH =[];
[r,c] = size(matrixHH);
for i = 1 : r
    xRow = matrixHH(i,:);
    rowsUp = upsample(xRow,2);
    rowsHp= conv(rowsUp,g1);
    matrixRH = [matrixRH;rowsHp];
end

% vertical 矩阵行操作
matrixRL =[];
for i = 1 : r
    xRow = matrixHL(i,:);
    rowsUp = upsample(xRow,2);
    rowsHp=conv(rowsUp,g0);
    matrixRL = [matrixRL;rowsHp];
end

% diagonal + vertical
matrixDia_Ver = matrixRH + matrixRL;
% diagonal + vertical 矩阵 upsample
matrixDia_Ver_up = upsample(matrixDia_Ver,2);

% 对求和后矩阵列操作，通过HP
matrixRHH=[];
[r,c] = size(matrixDia_Ver_up);
for i = 1 : c
    xcol = matrixDia_Ver_up(:,i);
    colsHp = conv(xcol,g1);
    matrixRHH = [matrixRHH;colsHp'];
end

% horizontal 矩阵行操作
matrixRH =[];
[r,c] = size(matrixLH);
for i = 1 : r
    xRow = matrixLH(i,:);
    rowsUp = upsample(xRow,2);
    rowsHp=conv(rowsUp,g1);
    matrixRH = [matrixRH;rowsHp];
end

% lowpass 矩阵行操作
matrixRL =[];
for i = 1 : r
    xRow = matrixLL(i,:);
    rowsUp = upsample(xRow,2);
    rowsHp=conv(rowsUp,g0);
    matrixRL = [matrixRL;rowsHp];
end

% horizontal + lowpass
matrixHor_Lp = matrixRH + matrixRL;
% horizontal + lowpass 矩阵 upsample
matrixHor_Lp_up = upsample(matrixHor_Lp ,2);

% 对求和后矩阵列操作，通过LP
matrixRLL=[];
[r,c] = size(matrixHor_Lp_up);
for i = 1 : c
    xcol = matrixHor_Lp_up(:,i);
    colsHp = conv(xcol,g0);
    matrixRLL = [matrixRLL;colsHp'];
end

%输出相加
matrix_y= 4 * (matrixRHH+matrixRLL);
matrix_y = matrix_y';

end

