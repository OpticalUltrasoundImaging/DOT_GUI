%outlier removal. used wave length 740 for its development but it can be used for all other wave length
%Grubbs' test

function [aba_r74,abp_r74] = outlierRemoval(aba_r741,abp_r741,source,detect)

aba_r74 = zeros(source,detect);
abp_r74 = zeros(source,detect);

for i=1:source
    for j=1:detect
        aba_r74(i,j) = removalAndReconstruct(aba_r741(:,i,j));
        abp_r74(i,j) = removalAndReconstruct(abp_r741(:,i,j));
    end
end

function [outValue] = removalAndReconstruct(inArray)  % inArray is a 1d array
    
    numOfDataRefFiles = size(inArray, 1);
    
    [array742,idx,outliers] = deleteoutliers(inArray,0.05,1);
    k1=0;
    for k=1:numOfDataRefFiles
        if isnan(array742(k)) == 0
            k1=k1+1;
            array743(k1) = array742(k);
        end
    end
    %74 quartile
    length74 = max(array743) - min(array743);
    ll = min(array743);
    ul1 = ll + length74/4;
    ul2 = ll + 2*length74/4;
    ul3 = ll + 3*length74/4;

    k1=0;
    k2=0;
    k3=0;
    k4=0;
    for k=1:length(array743)
        if array743(k) <= ul1
            k1=k1+1;
            array744(k1,1) = array743(k);
        elseif array743(k) > ul1 && array743(k) <= ul2
            k2=k2+1;
            array744(k2,2) = array743(k);
        elseif array743(k) > ul2 && array743(k) <= ul3
            k3=k3+1;
            array744(k3,3) = array743(k);
        else
            k4=k4+1;
            array744(k4,4) = array743(k);
        end
    end
    
    [max_num, max_idx] = max([ k1 k2 k3 k4 ]); 	% even there are more than 1 max value, the max_idx will be the first index of that max value
    
    %min distribution error
    array745 = array744(:,max_idx);
    if length(array745) > floor(numOfDataRefFiles / 4) + 1 % use to be 4
        param = mle(array745);
        for ii=1:length(array745)
            error(ii) = (array745(ii)-param(1))^2;
        end
        
        [value,index] = find(error==min(error));
        outValue = array745(index(1));
        clear error
    else
        outValue = mean(array744(array744 ~= 0));
    end