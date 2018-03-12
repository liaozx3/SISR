function result = calculate(img)
%2.1.4Ïà¹Øº¯Êý
    a = bicubic(img, floor(size(img,1)/3),floor(size(img,2)/3));
    b = bicubic(a,size(img,1),size(img,2));
    result(1) = myPSNR(img, b);
    result(2) = mySSIM(img, b);
end

