function [ output_img ] = bicubic( input, height, width )
    channel = size(input, 3);
    heightScale = height / size(input,1);
    widthScale = width / size(input,2);
    
    if channel == 3
        r = input(:,:,1);
        g = input(:,:,2);
        b = input(:,:,3);
        rr = zeros(height,width);
        gg = zeros(height,width);
        bb = zeros(height,width);

        for i=1:height
            for j=1:width
                x = min(size(input,1)-2, i/heightScale+0.5*(1-1/heightScale));
                y = min(size(input,2)-2, j/widthScale+0.5*(1-1/widthScale));
                xx = getX(x);
                yy = getY(y);
                sum = zeros(3,1);
                for k=1:4
                    for l=1:4
                        sum(1) = sum(1)+double(r(xx(k),yy(l)))*f(x-xx(k))*f(y-yy(l));
                        sum(2) = sum(2)+double(g(xx(k),yy(l)))*f(x-xx(k))*f(y-yy(l));
                        sum(3) = sum(3)+double(b(xx(k),yy(l)))*f(x-xx(k))*f(y-yy(l));
                    end
                end
                rr(i,j) = sum(1);
                gg(i,j) = sum(2);
                bb(i,j) = sum(3);
            end
        end

        output_img(:,:,1) = rr;
        output_img(:,:,2) = gg;
        output_img(:,:,3) = bb;

    else if channel == 1
            gray = zeros(height,width);
            
            for i=1:height
                for j=1:width
                    x = min(size(input,1)-2, i/heightScale+0.5*(1-1/heightScale));
                    y = min(size(input,2)-2, j/widthScale+0.5*(1-1/widthScale));
                    xx = getX(x);
                    yy = getY(y);
                    sum = 0;
                    for k=1:4
                        for l=1:4
                            sum = sum+double(input(xx(k),yy(l)))*f(x-xx(k))*f(y-yy(l));
                        end
                    end
                    gray(i,j) = sum;
                end
            end

            output_img = gray;
            
        end
    end
    
    output_img = uint8(output_img);
    
%---------------------------
    function w = f(x)
        absx = abs(x);
        absx2 = absx.^2;
        absx3 = absx.^3;
        if absx <= 1
            w = 1.5*absx3 - 2.5*absx2 + 1;
        else if absx <= 2
                w = -0.5*absx3 + 2.5*absx2 - 4*absx + 2;
            else
                w = 0;
            end
        end
    end
%---------------------------
    function fourX = getX(x)
        intx = floor(x);
        if intx < 2
            intx = 2;
        end
        fourX(1) = intx-1;
        fourX(2) = intx;
        fourX(3) = intx+1;
        fourX(4) = intx+2;
    end
%---------------------------
    function fourY = getY(y)
        inty = floor(y);
        if inty < 2
            inty = 2;
        end
        fourY(1) = inty-1;
        fourY(2) = inty;
        fourY(3) = inty+1;
        fourY(4) = inty+2;
    end
%---------------------------
end

