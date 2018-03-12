function [ psnr ] = myPSNR( input_img1, input_img2 )
    channel = size(input_img1, 3);
    MAXi = 255;
    if channel == 3                     %��RGBɫ�ʿռ�ת��YCbCr
        input_img1 = rgb2ycbcr(input_img1);  
        input_img2 = rgb2ycbcr(input_img2);
    end
    Y1 = double(input_img1(:, :, 1));    %�õ�Yͨ����Ҷ�ֵ��תΪdouble����
    Y2 = double(input_img2(:, :, 1));    
    D = Y1 - Y2;
    mse = sum(D(:).*D(:)) / numel(D);   
    psnr = 20*log10(MAXi / sqrt(mse));
end

