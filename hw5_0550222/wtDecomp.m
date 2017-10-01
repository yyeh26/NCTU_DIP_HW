function [A, H, V, D] = wtDecomp(imageIn, CHANNEL, wname) 
    level = 1
    for chnl = 1:CHANNEL 
        [C(:,:,chnl), S(:,:,chnl)] = wavedec2(imageIn(:,:,chnl),level,wname);    
        %Do the decomposition horizontally, vertically, and diagonally 
        [ H(:,:,chnl), V(:,:,chnl), D(:,:,chnl)] = detcoef2('all', C(:,:,chnl), S(:,:,chnl), level);
        % computes the approximation coefficients at level N 
        A(:,:,chnl) = appcoef2( C(:,:,chnl), S(:,:,chnl), 'haar', level );
    end
end