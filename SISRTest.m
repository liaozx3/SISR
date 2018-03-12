clc;
close all;

img_path_list = dir(strcat('./Set14/','*.bmp'));
scale = 3;
sum = [0 0];
for i = 1:length(img_path_list)
    img = imread(strcat('./Set14/',img_path_list(i).name));
    img1 = bicubic(img,floor(size(img,1)/scale),floor(size(img,2)/scale));
    height = size(img,1);
    width = size(img,2);
    tic;
    img2 = SISR(img1,scale,height,width);
    toc;
%     figure;
%     subplot(1,2,1),imshow(img);
%     subplot(1,2,2),imshow(img2);
    psnr = myPSNR(img,img2);
    ssim = mySSIM(img,img2);
    sum(1) = sum(1) + psnr;
    sum(2) = sum(2) + ssim;
    fprintf(strcat(img_path_list(i).name,' --- psnr: %f , ssim: %f\n'), psnr, ssim);
end

disp(sum/length(img_path_list));