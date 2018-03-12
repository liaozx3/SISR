function [ output_img ] = SISR( input, scale, height, width )
    if (size(input, 3) == 3)
        input = rgb2ycbcr(input);
        Y = input(:,:,1);
        cb = input(:,:,2);
        cr = input(:,:,3);
        output_img(:,:,1) = ScaleByMethod(Y, scale, height, width);
        output_img(:,:,2) = bicubic(cb, height, width);
        output_img(:,:,3) = bicubic(cr, height, width);
        output_img = ycbcr2rgb(output_img);
    else
        output_img = ScaleByMethod(input, scale, height, width);
    end
end

