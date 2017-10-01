function [EdgeImage, Process_A] = EdgeDetectionWL( A, LEVEL, Threshold)
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

    for indx_i = 1:Asize(1)
        for indx_j = 1:Asize(2)
            if ( Process_A( indx_i, indx_j, indx_k ) == 1  && Process_A( indx_i, indx_j, indx_k ) ==1 && Process_A( indx_i, indx_j, indx_k ) == 1)
                Edge_A( indx_i, indx_j) = 255 ;
            else
                Edge_A( indx_i, indx_j) = 0 ;
            end
        end
    end
    EdgeImage = imresize(edge(Edge_A,'canny'), 2^(LEVEL) ) ;
end