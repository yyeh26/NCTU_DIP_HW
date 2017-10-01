clc;
clear all;
filename = 'input1.bmp' ;
filename_ori = 'input1_ori.bmp' ;
in_image = imread(filename) ;
in_image_ori = imread(filename_ori) ;
figure()
imshow(in_image) ;
figure()
imshow(in_image_ori) ;

in_blur =  double(in_image) ;
in_ori  =  double(in_image_ori) ;
%%

%-----------------------Input 3 Wavelet Denoise--------------------------%
wname = 'bior3.5';
level = 5;
[C(:,:,1),S(:,:,1)] = wavedec2(in_blur(:,:,1),level,wname);
[C(:,:,2),S(:,:,2)] = wavedec2(in_blur(:,:,2),level,wname);
[C(:,:,3),S(:,:,3)] = wavedec2(in_blur(:,:,3),level,wname);

thr(:,:,1) = wthrmngr('dw2ddenoLVL','penalhi',C(:,:,1),S(:,:,1),3);
thr(:,:,2) = wthrmngr('dw2ddenoLVL','penalhi',C(:,:,2),S(:,:,2),3);
thr(:,:,3) = wthrmngr('dw2ddenoLVL','penalhi',C(:,:,3),S(:,:,3),3);

sorh = 's';

[ imageOut(:,:,1), cfsDEN(:,:,1), dimCFS(:,:,1) ] = wdencmp('lvd', C(:,:,1), S(:,:,1), wname, level, thr(:,:,1), sorh);
[ imageOut(:,:,2), cfsDEN(:,:,2), dimCFS(:,:,2) ] = wdencmp('lvd', C(:,:,2), S(:,:,2), wname, level, thr(:,:,2), sorh);
[ imageOut(:,:,3), cfsDEN(:,:,3), dimCFS(:,:,3) ] = wdencmp('lvd', C(:,:,3), S(:,:,3), wname, level, thr(:,:,3), sorh);

in_blur_wavelet  = (imageOut- min(min(min(imageOut))) ) *1.2 .* ( 1/ (max(max(max(imageOut)))-min(min(min(imageOut)))) ).*255; %normalization 
figure()
imshow( uint8( in_blur_wavelet ) ) ;

%%
%---------------------Input 3 MedienFilter Denoise------------------------%
in_blur_med(:,:,1) = medfilt2(in_blur(:,:,1));
in_blur_med(:,:,2) = medfilt2(in_blur(:,:,2));
in_blur_med(:,:,3) = medfilt2(in_blur(:,:,3));
imageOut = (in_blur_med - min(min(min(in_blur_med))) )  .* ( 1/ (max(max(max(in_blur_med)))-min(min(min(in_blur_med)))) ); %normalization  
figure()
imshow( uint8( imageOut*255)  );
err = immse(in_blur_med, in_ori)

%%
clc
%----------------------Input3 Image Restoration-------------------------%
hsize = 30;
sigma =  4.5; 
SNR = 0.1;
input_image = in_blur;


PSF = fspecial('gaussian', hsize, sigma) ;
pad_width = hsize ;

in_blur_pad(:,:,1) = padarray( input_image(:,:,1), [pad_width pad_width], 'symmetric' );
in_blur_pad(:,:,2) = padarray( input_image(:,:,2), [pad_width pad_width], 'symmetric' );
in_blur_pad(:,:,3) = padarray( input_image(:,:,3), [pad_width pad_width], 'symmetric' );
[height width channel] =  size(in_blur_pad) ;

G(:,:,1) = fft2( in_blur_pad(:,:,1) ) ;
G(:,:,2) = fft2( in_blur_pad(:,:,2) ) ;
G(:,:,3) = fft2( in_blur_pad(:,:,3) ) ;
H = psf2otf(PSF,[ height  width]);

F(:,:, 1) = ( conj(H) ./ ( abs(H.*conj(H)) + SNR ) ) .* G(:,:,1);
F(:,:, 2) = ( conj(H) ./ ( abs(H.*conj(H)) + SNR ) ) .* G(:,:,2);
F(:,:, 3) = ( conj(H) ./ ( abs(H.*conj(H)) + SNR ) ) .* G(:,:,3);

im_n=abs(ifft2(F)); %iFFT
imageOut  = im_n(pad_width+1:end-pad_width, pad_width+1:end-pad_width, :) ;
imageOut  = (imageOut- min(min(min(imageOut))) ) .* ( 1/ (max(max(max(imageOut)))-min(min(min(imageOut)))) ).*255; %normalization  
err = immse(imageOut, in_ori)

figure()
imshow( uint8( imageOut ) ) ;
title('Restored Image');
imwrite(uint8( imageOut ), 'Restored_Input3.bmp')
%%
clc
%-------------------------------Input 2----------------------------------%

LEN = 16;
THETA = 60;
SNR = 0.02;
PSF = fspecial('motion', LEN, THETA);
figure()
mesh(PSF);
pad_width = LEN
in_blur_pad(:,:,1) = padarray( in_blur(:,:,1), [pad_width pad_width], 'symmetric' );
in_blur_pad(:,:,2) = padarray( in_blur(:,:,2), [pad_width pad_width], 'symmetric' );
in_blur_pad(:,:,3) = padarray( in_blur(:,:,3), [pad_width pad_width], 'symmetric' );
[height width channel] =  size(in_blur_pad)

G(:,:,1) = fft2( in_blur_pad(:,:,1) ) ;
G(:,:,2) = fft2( in_blur_pad(:,:,2) ) ;
G(:,:,3) = fft2( in_blur_pad(:,:,3) ) ;

H = psf2otf(PSF,[ height  width]);

F(:,:, 1) = ( conj(H) ./ ( abs(H.*conj(H)) + SNR ) ) .* G(:,:,1);
F(:,:, 2) = ( conj(H) ./ ( abs(H.*conj(H)) + SNR ) ) .* G(:,:,2);
F(:,:, 3) = ( conj(H) ./ ( abs(H.*conj(H)) + SNR ) ) .* G(:,:,3);

im_n=abs(ifft2(F)); %iFFT
imageOut  = im_n(pad_width+1:end-pad_width, pad_width+1:end-pad_width, :) ;
imageOut  = (imageOut- min(min(min(imageOut))) ) .* ( 1/ (max(max(max(imageOut)))-min(min(min(imageOut)))) ).*255; %normalization 

figure()
imshow( uint8( imageOut ) ) ;
err = immse(imageOut, in_ori)
title('Restored Image');
imwrite(uint8( imageOut ), 'Restored_Input2.bmp')
%%

clc

%-------------------------Input 1 Restoration----------------------------%

hsize = 13 ;
sigma = 2.2 ; 

SNR = 0.0001;
PSF = fspecial('gaussian', hsize, sigma) ;
pad_width = 0;hsize
in_blur_pad(:,:,1) = padarray( in_blur(:,:,1), [pad_width pad_width], 'symmetric' );
in_blur_pad(:,:,2) = padarray( in_blur(:,:,2), [pad_width pad_width], 'symmetric' );
in_blur_pad(:,:,3) = padarray( in_blur(:,:,3), [pad_width pad_width], 'symmetric' );
[height width channel] =  size(in_blur_pad)


G(:,:,1) = fft2( in_blur_pad(:,:,1) ) ;
G(:,:,2) = fft2( in_blur_pad(:,:,2) ) ;
G(:,:,3) = fft2( in_blur_pad(:,:,3) ) ;

H = psf2otf(PSF,[ height  width]);
figure 
mesh(PSF)

F(:,:, 1) = ( conj(H) ./ ( abs(H.*conj(H)) + SNR ) ) .* G(:,:,1);
F(:,:, 2) = ( conj(H) ./ ( abs(H.*conj(H)) + SNR ) ) .* G(:,:,2);
F(:,:, 3) = ( conj(H) ./ ( abs(H.*conj(H)) + SNR ) ) .* G(:,:,3);

im_n=abs(ifft2(F)); %iFFT
imageOut  = im_n(pad_width+1:end-pad_width, pad_width+1:end-pad_width, :) ;
imageOut  = (imageOut- min(min(min(imageOut))) )*5 .* ( 1/ (max(max(max(imageOut)))-min(min(min(imageOut)))) ).*255; %normalization  

figure()
imshow( uint8( imageOut ) ) ;
err = immse(imageOut, in_ori)
title('Restored Image');
imwrite(uint8( imageOut ), 'Restored_Input1.bmp')