function [imageOut] = stRecover( A, H, V, D, CHANNEL, wname)
    for chnl = 1:CHANNEL  
        imageOut(:,:,chnl) = idwt2( A(:,:,chnl), H(:,:,chnl), V(:,:,chnl), D(:,:,chnl), wname);
    end
end