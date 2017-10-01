function imageOut = medianFilter(imageIn)
    filterSize = 3 ;
    imagePad = padarray( imageIn, [ filterSize-2, filterSize-2 ], 'symmetric');
    [ height width channel ] = size( imageIn ) ;
    imageOut = zeros( size( imageIn ) ) ;
    
    for i_chnl = 1:channel
        for i_width = 1:width
            for i_height = 1:height
                 median_index = 1 ;
                 for x_filter = -1:1
                     for y_filter = -1:1
                         medianBuff( median_index ) = imagePad( i_height+(filterSize-2)+x_filter, i_width+(filterSize-2)+y_filter, i_chnl ) ;
                         median_index = median_index + 1;
                     end
                 end
                 imageOut( i_height, i_width, i_chnl ) = median( medianBuff ) ; 
            end
        end
    end
end