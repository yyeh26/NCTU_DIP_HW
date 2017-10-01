clc
close all
clear all
filename = 'input3.bmp'

imageIn = imread(filename);

figure
image(uint8(imageIn) ) ;

%----------------------Frequency Domain Filtering------------------%
%%
%------Homomorphic Filter---------%
imageIn = double(imageIn);
imageOut = homoFilter( imageIn ) ;
figure
image(uint8( imageOut.*255) );
imwrite(uint8( imageOut.*255), 'Image_Homo.bmp')
%%
%------Histogram Equalization---------%
imageHis(:,:,1) = histeq(imageIn(:,:,1)./255);
imageHis(:,:,2) = histeq(imageIn(:,:,2)./255);
imageHis(:,:,3) = histeq(imageIn(:,:,3)./255);
figure
image(uint8( imageHis .* 255) )

imwrite(uint8( imageOut.*255), 'Image_Hist.bmp')

%----------------------Denoise------------------%
%%
%---------Bilateral Filter-----------%
w     = 2;       
sigma = [10 0.1]; 
bflt_img1 = bfilter2(imageOut,w,sigma);
image(bflt_img1)
imwrite(uint8( bflt_img1.*255 ), 'Image_BFLT.bmp')
%%
%---------Median Filter-----------%
A = medianFilter( imageOut.*255 );
figure 
image(uint8(A))
imwrite(uint8( A), 'Image_Median.bmp')
%%
%---------Mean Filter-----------%
A = meanFilter( imageOut.*255 );
%A = sharpFilter(A);
figure 
image(uint8(A))
imwrite(uint8( A), 'Image_Mean.bmp')
%%
%---------Wiener Filter-----------%
A(:,:,1) = wiener2( imageOut(:,:,1).*255, [5 5] );
A(:,:,2) = wiener2( imageOut(:,:,2).*255, [5 5] );
A(:,:,3) = wiener2( imageOut(:,:,3).*255, [5 5] );
figure 
image(uint8(A))
imwrite(uint8(A), 'Image_Wiener.bmp')