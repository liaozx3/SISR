function [ output_img ] = ScaleByMethod( input, scale, height, width )
    %default setting
    train_num = 320;
    LRpatchsPerImg_num = 1000;
    totalPatches = train_num * LRpatchsPerImg_num;
    LRpatchs = zeros(totalPatches, 45);
    HRpatchs = zeros(totalPatches, (3*scale)^2);
    
    %trainning
    count = 1;
    img_path_list = dir(strcat('./Train/','*.jpg'));
    for i = 1:train_num
        %read trainning image and get Y
        HRimg = imread(strcat('./Train/',img_path_list(i).name));
        HRimg = rgb2ycbcr(HRimg);
        HY = HRimg(:,:,1);
        
        %Gaussian kernel convolution and downsampling
        window = fspecial('gaussian', 7, 1.5);
        LY = bicubic(filter2(window, HY, 'same'), floor(size(HRimg,1)/3), floor(size(HRimg,2)/3));
        
        %get paired patches
        [lp, hp] = getPatch( LY, HY, scale, LRpatchsPerImg_num );
        for j = 1:LRpatchsPerImg_num
           LRpatchs(count,:) = lp(j,:);
           HRpatchs(count,:) = hp(j,:);
           count = count+1;
        end
    end

    %kmeans
    k = 1024;
    opts = statset('Display','final','MaxIter',500);
    [idx,C] = kmeans(LRpatchs,k,'Options',opts);
%     [idx,C] = kmeans(LRpatchs, k);
    %divide into K cluster and get Wi,Vi
    LRtype = zeros(45,1,k);
    HRtype = zeros((3*scale)^2,1,k);
    counter = ones(1,k);
    for i = 1:totalPatches
        LRtype(:,counter(idx(i)),idx(i)) = LRpatchs(i,:);
        HRtype(:,counter(idx(i)),idx(i)) = HRpatchs(i,:);
        counter(idx(i)) = counter(idx(i))+1;
    end
    %get Ci
    Coef = zeros((3*scale)^2,45,k);
    for i = 1:k
        V = LRtype(:,(1:counter(idx(i))-1),i);
        W = HRtype(:,(1:counter(idx(i))-1),i);
        Coef(:,:,i) = getCoef(V, W);
    end
    
%     -------save data-------
    save data.mat Coef C
%     -----------------------
%     ----------load data-------
%     load data.mat;
%     ------------------------
    
    %traverse
    output_img = bicubic(input,height,width);
    Lp = zeros(1,45);
    for i = 1:3:size(input,1)-6
        for j = 1:3:size(input,2)-6
            count = 1;
            for m = 1:7
               for n = 1:7
                   if ((m==1 && (n==1 || n==7)) || (m==7 && (n==1 || n==7)))  %È¥³ý4¸ö½Ç
                       continue;
                   end
                   Lp(count) = input(i+m-1,j+n-1);
                   count = count+1;
               end
            end
            
            k = getType(C,Lp);
            Hp = Coef(:,:,k)*Lp';
            count = 1;
            for m = 1:3*scale
               for n = 1:3*scale
                   output_img((i+1)*scale+m, (j+1)*scale+n) = Hp(count,:);
                   count = count+1;
               end
            end
            
        end
    end
    
    output_img = uint8(output_img);
end

