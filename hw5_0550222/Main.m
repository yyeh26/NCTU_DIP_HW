clc ;
clear all ;
close all ; 
filename = 'input2.bmp' ;
in_image = imread(filename) ;

figure()
imshow(in_image) ;
imageIn =  double(in_image) ;
sizeImage = size(imageIn)

CHANNEL = 3;
wname = 'haar'

%%
[ImageOut TEMP] = func_denoise_wp2d(imageIn);
figure()
imshow(uint8(ImageOut))
imwrite(uint8(ImageOut), 'Denoise.png')
%%

%--------------------Edge Detection-------------------------%
close all
[A1, H1, V1, D1] = wtDecomp(imageIn, CHANNEL, wname);
[A2, H2, V2, D2] = wtDecomp(A1, 3, wname);
[A3, H3, V3, D3] = wtDecomp(A2, 3, wname);
[A4, H3, V3, D3] = wtDecomp(A3, 3, wname);


% Put on edge line
ProcessIm1 = WLDecompIm( H2+V2, 1, 20) ;
LEVEL = 2
EdgeImage1 = imresize( ProcessIm1(:,:,1),4 ) ;

figure 
imshow(EdgeImage1)

ProcessIm2 = WLDecompIm( A1, 1, 110)  ;
ProcessIm3 = WLDecompIm( A1, 1, 80 )  ;
% EdgeImage2 = EdgeDetectionWL( A1, 1, 280) ;
% EdgeImage3 = EdgeDetectionWL( A2, 2, 255) ;
figure 
imshow(ProcessIm1(:,:,3))
% figure 
% imshow(ProcessIm2(:,:,2))
% figure 
% imshow(ProcessIm3(:,:,2))
% figure
% imshow(EdgeImage2)
% figure 
% imshow(EdgeImage3)
%%
close all
%----------------Morphology---------------%
imageMorphIn = ProcessIm3(:,:,3);
figure 
imshow(imageMorphIn )

wsize = 4;
SE = strel('Square',wsize);
morphOut3 = imopen(imageMorphIn, SE );
morphOut3 = imcomplement(morphOut3);
morphOut3 = imopen(morphOut3,SE );
morphOut3 = imcomplement(morphOut3);


figure 
imshow(morphOut3)

%%
close all
%----------------Morphology---------------%
imageMorphIn = ProcessIm2(:,:,3);
figure 
imshow(imageMorphIn )

wsize = 3;
SE = strel('Square',wsize);
morphOut2 = imdilate(imageMorphIn,SE );
wsize = 4;
SE = strel('Square',wsize);
morphOut2 = imopen(morphOut2, SE );
morphOut2 = imcomplement(morphOut2);
morphOut2 = imopen(morphOut2,SE );
morphOut2 = imcomplement(morphOut2);
figure 
imshow(morphOut2)

%%
close all
%----------------Morphology---------------%
imageMorphIn = ProcessIm1(:,:,2);
figure 
imshow(imageMorphIn )

wsize = 2;
SE = strel('Square',wsize);
morphOut1 = imdilate(imageMorphIn,SE );
morphOut1 = imopen(morphOut1,SE );
morphOut1 = imclose(morphOut1,SE );
figure 
imshow(morphOut1 )


morphOut1 = imcomplement(morphOut1);
wsize = 3;
SE = strel('Square',wsize);
morphOut1 = imopen(morphOut1,SE );
morphOut1 = imclose(morphOut1,SE );

morphOut1 = imcomplement(morphOut1);
figure 
imshow(morphOut1 )

%%
LEVEL = 1
EdgeImage1 = imresize(edge(morphOut1,'canny'), 2^(LEVEL) ) ;
EdgeImage2 = imresize(edge(morphOut2,'canny'), 2^(LEVEL) ) ;
EdgeImage3 = imresize(edge(morphOut3,'canny'), 2^(LEVEL) ) ;

figure
imshow(EdgeImage1)

%%
imageInEdge = imageIn ; 
Asize = size(imageInEdge)

for indx_i = 1:Asize(1)
    for indx_j = 1:Asize(2)
        if ( EdgeImage1( indx_i, indx_j ) == 1  )
            imageInEdge( indx_i, indx_j, 1) = 222 ;
            imageInEdge( indx_i, indx_j, 2) = 29;
            imageInEdge( indx_i, indx_j, 3) = 42 ;
        end
    end
end

figure()
imshow(uint8( imageInEdge) );
imwrite(uint8(imageInEdge), 'Segmentation.png')

