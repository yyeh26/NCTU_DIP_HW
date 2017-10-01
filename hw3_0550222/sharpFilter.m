function imageOut = sharpFilter(imageIn)
    filterSize = 3 ;
    imagePad = padarray( imageIn, [ filterSize-2, filterSize-2 ], 'symmetric');
    [ height width channel ] = size( imageIn ) ;
    imageOut = zeros( size( imageIn ) ) ;
    filter = [0 -1 0 ; -1 4 -1 ; 0 -1 0 ] ;
    
    for i_chnl = 1:channel
        for i_width = 1:width
            for i_height = 1:height
                 sum_pixel = 0 ; 
                 for x_filter = -1:1
                     for y_filter = -1:1
                         sum_pixel = sum_pixel + imagePad( i_height+(filterSize-2)+x_filter, i_width+(filterSize-2)+y_filter, i_chnl ) * filter(x_filter + 2 , y_filter + 2);
                     end
                 end
                 imageOut( i_height, i_width, i_chnl ) =   imageIn( i_height, i_width, i_chnl ) + 0.7*sum_pixel;
            end
        end
    end
end