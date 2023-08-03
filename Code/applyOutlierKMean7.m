function [pert,Measmnt,sddist,pairs] = applyOutlierKMean7(pertXX_2d,MeasmntXX,sddistXX,pairsXX,source,detect)

% pert = pertXX_2d;           % for test only 
% Measmnt = MeasmntXX;
% sddist = sddistXX;
% return;

k_value = 7;        		% k-mean cluster numbers
dist_value_inner = 0.7;     % distance from (0, 0)
dist_value_outer = 1.1;     % distance from (0, 0)
c_value = 10;       		% member threshold to eliminate

numOfFiles = length(pertXX_2d);             % pertXX_2d format is one cell one data file
pert = cell(1,numOfFiles);                  % need a cell array because of uneven pert arrays after their outliers are removed
Measmnt = cell(1,numOfFiles);
sddist = cell(1,numOfFiles);
pairs = cell(1,numOfFiles);

for k = 1:numOfFiles
    pertXX = pertXX_2d{k};
    dataXX = [real(pertXX)',imag(pertXX)'];
    
    rng(1);
    [idx,C] = kmeans(dataXX,k_value);       % IDX = KMEANS(X, K) partitions the points in the N-by-P data matrix X into K clusters
    
    for kk = 1:k_value
        dist = sqrt(C(kk,1)^2+C(kk,2)^2);   % distance to (0, 0)

        % points in that cluster are less than 10 and its cluster center is further than 0.7
%         if (length(dataXX(idx==kk,1)) < c_value) && (dist > dist_value_inner)	
%             dataXX(idx==kk,:) = NaN;        % to keep data position
%         elseif dist > dist_value_outer
%             dataXX(idx==kk,:) = NaN;        % to keep data position
%         end
        if dist > dist_value_outer
            dataXX(idx==kk,:) = NaN;        % to keep data position
        end
    end
    
    MeasmntTemp = MeasmntXX{k};
    sddistTemp = sddistXX{k};
    pairsTemp = pairsXX{k};
    
    idxNaN = find(isnan(dataXX(:,1)));      % find those which are needed to delete
    if ~isempty(idxNaN)
        dataXX(idxNaN,:) = [];
        MeasmntTemp(idxNaN,:) = [];         % remove those which are corresponding to NaN
        sddistTemp(idxNaN) = [];
    end
    
    counter = 1;
    for ii=1:source;
        for jj=1:detect;
            if pairsTemp(ii,jj) == 1
                found = find(idxNaN == counter);
                if ~isempty(found)
                    pairsTemp(ii,jj) = 0;
                end
                counter = counter + 1;
            end
        end
    end
   
    dataLength = size(dataXX,1);
    pertXX = zeros(1,dataLength);
    for kk = 1:dataLength
        pertXX(kk) = complex(dataXX(kk,1),dataXX(kk,2));
    end
    
    pert{k} = pertXX;
    sddist{k} = sddistTemp;
    Measmnt{k} = MeasmntTemp;
    pairs{k} = pairsTemp;
end
    
return;


