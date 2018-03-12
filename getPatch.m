function [ LRpatchs, HRpatchs ] = getPatch( inputLR, inputHR, scale, patch_num )
    LRpatchs = zeros(patch_num,45);
    HRpatchs = zeros(patch_num,(3*scale)^2);
    
    randx = randi(size(inputLR,1)-7,1,patch_num);
    randy = randi(size(inputLR,2)-7,1,patch_num);
    for i = 1:patch_num
        count = 1;
        sum = 0;
        for j = 1:7
           for k = 1:7
               if ((j==1 && (k==1 || k==7)) || (j==7 && (k==1 || k==7)))  %È¥³ý4¸ö½Ç
                   continue;
               end
               LRpatchs(i,count) = inputLR(randx(i)+j-1,randy(i)+k-1);
               count = count+1;
               sum = sum + inputLR(randx(i)+j-1,randy(i)+k-1);
           end
        end
        mu = sum/45;
        LRpatchs(i,:) = LRpatchs(i,:) - double(mu);
        
        count = 1;
        for p = 1:3*scale
           for q = 1:3*scale
              HRpatchs(i,count) = inputHR((randx(i)+1)*scale+p,(randy(i)+1)*scale+q) - double(mu);
              count = count+1;
           end
        end
        
    end

end

