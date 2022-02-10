function matrix_y = Reconstruct_N(inputIMG,N_decimator)
%% RECONSTRUCT 此处显示有关此函数的摘要
%   此处显示详细说明
h0 = [0.3415 0.5915 0.1585 -0.0915];
h1 = [0.0915 0.1585 -0.5915 0.3415];
g0 = [-0.0915 0.1585 0.5915 0.3415];
g1 = [0.3415 -0.5915 0.1585 0.0915];
%% Diagonal HH
[N,C] = size(inputIMG);
matrixH =[];
% 行操作
for i = 1 : N
    xRow = inputIMG(i,:);
    rowsHp=conv(xRow,h1);
    rowsHpNew = downsample(rowsHp,N_decimator);
    matrixH = [matrixH;rowsHpNew];
end

% 列操作
matrixHH =[];
[r,c] = size(matrixH);
for i = 1 : c
    xcol = matrixH(:,i);
    colsHp=conv(xcol',h1);
    colsHpNew = downsample(colsHp,N_decimator);
    matrixHH = [matrixHH;colsHpNew];
end
matrixHH= matrixHH';

%% Vertical HL
matrixH =[];
% 行操作
for i = 1 : N
    xRow = inputIMG(i,:);
    rowsHp=conv(xRow,h1);
    rowsHpNew = downsample(rowsHp,N_decimator);
    matrixH = [matrixH;rowsHpNew];
end

% 列操作
matrixHL =[];
[r,c] = size(matrixH);
for i = 1 : c
    xcol = matrixH(:,i);
    colsLp=conv(xcol',h0);
    colsLpNew = downsample(colsLp,N_decimator);
    matrixHL = [matrixHL;colsLpNew];
end
matrixHL= matrixHL';

%% Horizontal LH
matrixL =[];
% 行操作
for i = 1 : N
    xRow = inputIMG(i,:);
    rowsLp=conv(xRow,h0);
    rowsLpNew = downsample(rowsLp,N_decimator);
    matrixL = [matrixL;rowsLpNew];
end
% 列操作
matrixLH =[];
[r,c] = size(matrixL);
for i = 1 : c
    xcol = matrixL(:,i);
    colsHp=conv(xcol',h1);
    colsHpNew = downsample(colsHp,N_decimator);
    matrixLH = [matrixLH;colsHpNew];
end
matrixLH= matrixLH';

%% Lowpass LL
matrixL =[];
% 行操作
for i = 1 : N
    xRow = inputIMG(i,:);
    rowsLp=conv(xRow,h0);
    rowsLpNew = downsample(rowsLp,N_decimator);
    matrixL = [matrixL;rowsLpNew];
end
% matrixL
% 列操作
matrixLL =[];
[r,c] = size(matrixL);
for i = 1 : c
    xcol = matrixL(:,i);
    colsLp = conv(xcol',h0);
    colsLpNew = downsample(colsLp,N_decimator);
    matrixLL = [matrixLL;colsLpNew];
end
matrixLL= matrixLL';

%% Reconstruction
% reconstruct HH
% diagonal 矩阵行操作
matrixRH =[];
[r,c] = size(matrixHH);
for i = 1 : r
    xRow = matrixHH(i,:);
    rowsUp = upsample(xRow,N_decimator);
    rowsHp= conv(rowsUp,g1);
    matrixRH = [matrixRH;rowsHp];
end

% vertical 矩阵行操作
[r,c] = size(matrixHL);
matrixRL =[];
for i = 1 : r
    xRow = matrixHL(i,:);
    rowsUp = upsample(xRow,N_decimator);
    rowsHp=conv(rowsUp,g0);
    matrixRL = [matrixRL;rowsHp];
end

% diagonal + vertical
matrixDia_Ver = matrixRH + matrixRL;
% diagonal + vertical 矩阵 upsample
matrixDia_Ver_up = upsample(matrixDia_Ver,N_decimator);

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
    rowsUp = upsample(xRow,N_decimator);
    rowsHp=conv(rowsUp,g1);
    matrixRH = [matrixRH;rowsHp];
end

% lowpass 矩阵行操作
matrixRL =[];
[r,c] = size(matrixLL);
for i = 1 : r
    xRow = matrixLL(i,:);
    rowsUp = upsample(xRow,N_decimator);
    rowsHp=conv(rowsUp,g0);
    matrixRL = [matrixRL;rowsHp];
end

% horizontal + lowpass
matrixHor_Lp = matrixRH + matrixRL;
% horizontal + lowpass 矩阵 upsample
matrixHor_Lp_up = upsample(matrixHor_Lp ,N_decimator);

% 对求和后矩阵列操作，通过LP
matrixRLL=[];
[r,c] = size(matrixHor_Lp_up);
for i = 1 : c
    xcol = matrixHor_Lp_up(:,i);
    colsHp = conv(xcol,g0);
    matrixRLL = [matrixRLL;colsHp'];
end

%输出相加
matrix_y= 2 *N_decimator * (matrixRHH+matrixRLL);
matrix_y = matrix_y';

end

