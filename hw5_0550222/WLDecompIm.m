function Process_A = WLDecompIm( A, LEVEL, Threshold) 
% This function will Thresholding the Wavelet-decomposited image and return
% the 0 1 regional image 
    Process_A = A;
    Asize = size(Process_A);
    for indx_i = 1:Asize(1)
        for indx_j = 1:Asize(2)
            for indx_k = 1:Asize(3)
                if ( Process_A( indx_i, indx_j, indx_k ) >= Threshold)
                    Process_A( indx_i, indx_j, indx_k ) = 0 ;
                else
                    Process_A( indx_i, indx_j, indx_k ) = 1 ;
                end
            end
        end
    end
end