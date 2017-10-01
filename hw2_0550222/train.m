function [R_factor G_factor B_factor] = train( imageIn, CIERGB, FEATURE_DIM, TRAINSET)
    NUMTRAIN   = 24*TRAINSET ;
    Y_INTERVAL = 90          ;
    X_INTERVAL = 105         ;
    INDEX_UPPER = [182 275]  ;
    SPAN = [10, 7]           ;
    X_trainR = zeros([NUMTRAIN FEATURE_DIM], 'double');
    Y_trainR = zeros([NUMTRAIN 1]);
    X_trainG = zeros([NUMTRAIN FEATURE_DIM], 'double');
    Y_trainG = zeros([NUMTRAIN 1]);
    X_trainB = zeros([NUMTRAIN FEATURE_DIM], 'double');
    Y_trainB = zeros([NUMTRAIN 1]);
    index1 = 1;
    fprintf( 'Training... ');
    for trainset = 1: TRAINSET
        for y_color = 1:4   
            for x_color = 1:6 
            x_testpixel = INDEX_UPPER(1) + (x_color-1) * X_INTERVAL + randi([1, SPAN(1)] )-1;
            y_testpixel = INDEX_UPPER(2) + (y_color-1) * Y_INTERVAL + randi([1, SPAN(2)] )-1;

            X_trainR(index1,:) = featureX( imageIn(y_testpixel, x_testpixel, :) );
            Y_trainR(index1) = CIERGB( y_color, x_color, 1 ) ;
            X_trainG(index1,:) = featureX( imageIn(y_testpixel, x_testpixel, :) );
            Y_trainG(index1) = CIERGB( y_color, x_color, 2 ) ;
            X_trainB(index1,:) = featureX( imageIn(y_testpixel, x_testpixel, :) );
            Y_trainB(index1) = CIERGB( y_color, x_color, 3 ) ;
            
            index1 = index1 + 1;
            end
        end
    end
    R_factor = fitlm(X_trainR,Y_trainR);
    G_factor = fitlm(X_trainG,Y_trainG);
    B_factor = fitlm(X_trainB,Y_trainB);
    fprintf( 'Training Complete');
end