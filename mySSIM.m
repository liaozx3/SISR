function [ ssim ] = mySSIM( input_img1, input_img2 )
    channel = size(input_img1, 3);
    if channel == 3                    %将RGB色彩空间转到YCbCr
        input_img1 = rgb2ycbcr(input_img1);  
        input_img2 = rgb2ycbcr(input_img2);
    end
    Y1 = double(input_img1(:, :, 1));    %得到Y通道或灰度值并转为double类型
    Y2 = double(input_img2(:, :, 1)); 
    
    k1 = 0.01;      %默认值
    k2 = 0.03;
    L = 255;
    window = fspecial('gaussian', 11, 1.5);
    
    c1 = k1*k1*L*L;         %用来维持稳定的常数
    c2 = k2*k2*L*L;
    window = window/sum(sum(window));  %滤波器归一化操作
    
    mu1 = filter2d(Y1, window);
    mu2 = filter2d(Y2, window);

    sigma1_sq = filter2d(Y1.*Y1,window) - mu1.*mu1;  %sigmax
    sigma2_sq = filter2d(Y2.*Y2,window) - mu2.*mu2;  %sigmay
    sigma12 = filter2d(Y1.*Y2,window) - mu1.*mu2;    %sigmaxy
    ssim_map = ((2*mu1.*mu2 + c1).*(2*sigma12 + c2))./((mu1.*mu1 + mu2.*mu2 + c1).*(sigma1_sq + sigma2_sq + c2));
    ssim = mean2(ssim_map);

end

