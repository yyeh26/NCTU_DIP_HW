function feature = featureX( pixel )
    feature = [ pixel(1) pixel(2) pixel(3)  pixel(1)*pixel(2) pixel(2)*pixel(3)  pixel(1)*pixel(3)  pixel(1)*pixel(1)  pixel(2)*pixel(2) pixel(3)*pixel(3) pixel(1)*pixel(2)*pixel(3) pixel(2)*pixel(3)*pixel(3) ];
end