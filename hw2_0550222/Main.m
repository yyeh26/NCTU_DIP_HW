clc;
clear all;

%--------------------------------INPUT-----------------------------------%
filename = 'input1.bmp'
BITLIMIT   = 255         ; 
RGB2XYZ = [ 0.412453 0.357580 0.180423 ; 0.212671 0.715160 0.072169 ; 0.019334 0.119193 0.950227 ]

fileRGB = fopen('CIERGB.txt', 'r')
temp    = fscanf(fileRGB, '%d')
CIERGB = zeros([4, 6, 3]);
for indx1 = 1: 4
    for indx2 = 1:6
        CIERGB(indx1, indx2, 1)  = temp( ( (indx1-1)*6 + (indx2-1))*3 + 1);
        CIERGB(indx1, indx2, 2)  = temp( ( (indx1-1)*6 + (indx2-1))*3 + 2);
        CIERGB(indx1, indx2, 3)  = temp( ( (indx1-1)*6 + (indx2-1))*3 + 3);
    end
end
in_image = imread(filename) ;
[ height width channel] = size(in_image)

figure
image(in_image)
imageIn_double = double(in_image);
%%
%----------------------TRAINING--------------------------------%
%RMSE = [];
%GMSE = [];
%BMSE = [];
clc
FEATURE_DIM = 11
TRAINSET  = 1;
%for TRAINSET = 1 : 10 :1000
[R_Regr G_Regr B_Regr] = train(imageIn_double, CIERGB, FEATURE_DIM, TRAINSET)
RecoverR = transpose( table2array(R_Regr.Coefficients(:, 1) ) );
RecoverG = transpose( table2array(G_Regr.Coefficients(:, 1) ) );
RecoverB = transpose( table2array(B_Regr.Coefficients(:, 1) ) );
%RMSE = [RMSE R_Regr.RMSE];
%GMSE = [GMSE G_Regr.RMSE];
%BMSE = [BMSE B_Regr.RMSE];
%end

%%
clc

imageOut = zeros( size(in_image), 'uint8' );

for idx1 = 1: height
    for idx2 = 1:width
        imageOut(idx1, idx2, 1) = uint8( RecoverR(2:FEATURE_DIM+1) * transpose( featureX( imageIn_double(idx1, idx2, :) ) ) + RecoverR(1) );
        imageOut(idx1, idx2, 2) = uint8( RecoverG(2:FEATURE_DIM+1) * transpose( featureX( imageIn_double(idx1, idx2, :) ) ) + RecoverG(1) );
        imageOut(idx1, idx2, 3) = uint8( RecoverB(2:FEATURE_DIM+1) * transpose( featureX( imageIn_double(idx1, idx2, :) ) ) + RecoverB(1) );
    end
end
figure 
image(imageOut) 
imwrite(imageOut, 'input1_WB.bmp')
%%
%-------------------------------Problem Set 2--------------------------------&
Y_INTERVAL = 90          ;
X_INTERVAL = 105         ;
INDEX_UPPER = [182 275]  ;

%-------------------SET TARGET STYLE----------------------------%
% filename = 'input1.bmp'  ;
% imageRGB_Style  = imread(filename) ;
% for y_color = 1:4   
%     for x_color = 1:6
%             x_testpixel = INDEX_UPPER(1) + (x_color-1)*X_INTERVAL ;
%             y_testpixel = INDEX_UPPER(2) + (y_color-1)*Y_INTERVAL ;
%             RGB_STYLE(y_color, x_color, 1) = imageRGB_Style(y_testpixel, x_testpixel, 1);
%             RGB_STYLE(y_color, x_color, 2) = imageRGB_Style(y_testpixel, x_testpixel, 2);
%             RGB_STYLE(y_color, x_color, 3) = imageRGB_Style(y_testpixel, x_testpixel, 3);
%     end
% end
RGB_STYLE = CIERGB;
%White
RGB_STYLE( 4, 1, 1) = 220;
RGB_STYLE( 4, 1, 2) = 220;
RGB_STYLE( 4, 1, 3) = 220;
%Nerutral
RGB_STYLE( 4, 2, 1) = 190;
RGB_STYLE( 4, 2, 2) = 190;
RGB_STYLE( 4, 2, 3) = 190;
%Nerutral65
RGB_STYLE( 4, 3, 1) = 160;
RGB_STYLE( 4, 3, 2) = 160;
RGB_STYLE( 4, 3, 3) = 160;
%Grenn
RGB_STYLE( 3, 2, 1) = 237;
RGB_STYLE( 3, 2, 2) = 164;
RGB_STYLE( 3, 2, 3) = 65;
%Yellow Green
RGB_STYLE( 2, 5, 1) = 224;
RGB_STYLE( 2, 5, 2) = 199;
RGB_STYLE( 2, 5, 3) = 99;
%Blue Sky
RGB_STYLE( 1, 3, 1) = 79;
RGB_STYLE( 1, 3, 2) = 98;
RGB_STYLE( 1, 3, 3) = 125;
%Bluish Green
RGB_STYLE( 1, 6, 1) = 163;
RGB_STYLE( 1, 6, 2) = 158;
RGB_STYLE( 1, 6, 3) = 118;
%Cyan
RGB_STYLE( 3, 6, 1) = 27;
RGB_STYLE( 3, 6, 2) = 51;
RGB_STYLE( 3, 6, 3) = 59;
image(uint8(RGB_STYLE))
%%
%-----------------------ORIGINAL INPUT------------------------%
filename = 'input1_WB.bmp'  ;
imageOrigin  = imread(filename) ;
figure
image(imageOrigin)
imageOrigin_double = double(imageOrigin);

%%
%----------------------TRAINING--------------------------------%
clc
FEATURE_DIM = 11;
TRAINSET = 1000;
[R_Regr G_Regr B_Regr] = train(imageOrigin_double, RGB_STYLE, FEATURE_DIM, TRAINSET)
RecoverR = transpose( table2array(R_Regr.Coefficients(:, 1) ) );
RecoverG = transpose( table2array(G_Regr.Coefficients(:, 1) ) );
RecoverB = transpose( table2array(B_Regr.Coefficients(:, 1) ) ); 

%%
clc

filename = 'input2.bmp'  ;
imageIn  = imread(filename) ;
figure
image(imageIn);

[height width channel] = size(imageIn) ;
imageIn_double = double(imageIn) ;
imageOut = zeros( size(imageIn), 'uint8' );
UPFACTOR = 0;
for idx1 = 1: height
    for idx2 = 1:width
        imageOut(idx1, idx2, 1) = uint8( RecoverR(2:FEATURE_DIM+1) * transpose( featureX( imageIn_double(idx1, idx2, :) ) )  + RecoverR(1) );
        imageOut(idx1, idx2, 2) = uint8( RecoverG(2:FEATURE_DIM+1) * transpose( featureX( imageIn_double(idx1, idx2, :) ) )  + RecoverG(1));
        imageOut(idx1, idx2, 3) = uint8( RecoverB(2:FEATURE_DIM+1) * transpose( featureX( imageIn_double(idx1, idx2, :) ) )  + RecoverB(1) );
    end
end

figure 
image(imageOut) 
imwrite(imageOut, 'input2_Style.bmp')

