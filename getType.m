function [ k ] = getType(C,Lp)
    min = realmax;
    for i = 1:size(C,1)
        tmp = C(i,:)-Lp;
        s = sum(tmp(:).^2);
        if s < min
           min =  s;
           k = i;
        end
    end
end

