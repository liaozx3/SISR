function [ output_img ] = filter2d( input, filter )
    R = size(input,1);
    C = size(input,2);
    r = size(filter,1);
    c = size(filter,2);
    %valid 不考虑边界补零，即只要有边界补出的零参与运算的都舍去
    output_img = zeros(R-r+1, C-c+1);
    
    filter_new = zeros(r,c);
    for i = 1:r
        for j = 1:c
            filter_new(i,j) = filter(r - i + 1, c - j + 1);
        end
    end

    for i=1:R-r+1
        for j=1:C-c+1
            sum = 0;
            for k = 1:r
                for l=1:c
                    sum = sum+filter_new(k,l)*input(i-1+k, j-1+l);
                end
            end
            output_img(i,j) = sum;
        end
    end

end

