function imageOut = homoFilter( imageIn ) 
[im_height im_width im_channel]=size(imageIn);
d = 10;
alphaL = 1.1%.55;
aplhaH = .3%.3;

%---------------Filters------------------------%
% A = zeros( im_height, im_width );
% 
% for indx=1:im_height
%     for jndx=1:im_width
%         A(indx,jndx) = ( ( (indx-im_height/2).^2 + (jndx-im_width/2).^2) ).^( .5 );
%         H(indx,jndx) = 1 / ( 1+( (d/A(indx,jndx))^(2*im_channel) ) );
%     end
% end
% H=((aplhaH-alphaL).*H)+alphaL;
% 
% figure 
% mesh(H)
%---------------Gaussian Filter---------------%
sigma = 5;
[X, Y] = meshgrid(1:im_width,1:im_height);
centerX = ceil(im_width/2);
centerY = ceil(im_height/2);
gaussianNumerator = (X - centerX).^2 + (Y - centerY).^2;
H = exp(-gaussianNumerator./(2*sigma.^2)).*1.2+0.25;

sizeH = size(H)
sizeI = size(imageIn)
figure 
mesh(H)
%------------------Filtering------------------%
im = imageIn;
mean(mean(mean(imageIn)))
im_l = log2(1+im);
im_f = fft2(im_l);  % FFT

im_nf(:,:,1) = H.*im_f(:,:,1); % Filtering out High frequency noise
im_nf(:,:,2) = H.*im_f(:,:,2);
im_nf(:,:,3) = H.*im_f(:,:,3);

im_n=abs(ifft2(im_nf)); %iFFT
im_e= exp(im_n)-1 ;

imageOut = (im_e - min(min(min(im_e))) ) .* ( 1/ (max(max(max(im_e)))-min(min(min(im_e)))) ); %normalization  
end