clc;
close all;

sum = [0 0];
img_path_list = dir(strcat('./Set14/','*.bmp'));
calculations = zeros(length(img_path_list),2);
for i = 1:length(img_path_list)
    img = imread(strcat('./Set14/',img_path_list(i).name));
    calculations(i,:) = calculate(img);
    fprintf(strcat(img_path_list(i).name,' --- psnr: %f ,  ssim: %f\n'), calculations(i,:));
    sum = sum+calculations(i,:);
end

disp(sum/length(img_path_list));
