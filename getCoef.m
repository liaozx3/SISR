function [ Coef ] = getCoef( LRmat, HRmat )
    %LRmat(size(LRmat,1)+1,:) = ones(1,size(LRmat,2));
%     Coef = zeros(size(HRmat,1),size(LRmat,1)+1);
    Coef = HRmat / LRmat;
end

