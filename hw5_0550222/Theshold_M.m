function imageOut = Theshold_M( imageIn, theshold, threshold_value )
    isize = size(imageIn) ;
    for indx_i = 1:isize(1)
        for indx_j = 1:isize(2)
            for indx_k = 1:isize(3)
                if abs( imageIn(indx_i, indx_j, indx_k) ) > theshold
                    imageOut(indx_i, indx_j, indx_k) = threshold_value;
                end
            end
        end
    end
end