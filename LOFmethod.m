function [pert,Measmnt,sddist,pairs] = LOFmethod(pertXX_2d,MeasmntXX,sddistXX,pairsXX,source,detect)

numOfFiles = length(pertXX_2d);             % pertXX_2d format is one cell one data file
pert = cell(1,numOfFiles);                  % need a cell array because of uneven pert arrays after their outliers are removed
Measmnt = cell(1,numOfFiles);
sddist = cell(1,numOfFiles);
pairs = cell(1,numOfFiles);

for k = 1:numOfFiles
    pertXX = pertXX_2d{k};
    dataXX = [real(pertXX).',imag(pertXX).'];
%     figure;plot(dataXX(:,1),dataXX(:,2),'.');hold on;
%     ang = 0:0.01:2*pi; xp = cos(ang);yp = sin(ang);plot(xp,yp);
    
    DataSet = DDOutlier.dataSet(dataXX,'euclidean');
    [~,max_nb] = DDOutlier.NaNSearching(DataSet);
%     [nofs] = DDOutlier.NOFs(DataSet,max_nb);
    [lofs] = DDOutlier.LOFs(DataSet,max_nb);
    idxLOF = find(lofs > 2);
%     plot(dataXX(idx,1),dataXX(idx,2),'r.')
    
    MeasmntTemp = MeasmntXX{k};
    sddistTemp = sddistXX{k};
    pairsTemp = pairsXX{k};
    
    if ~isempty(idxLOF)
        dataXX(idxLOF,:) = [];
        MeasmntTemp(idxLOF,:) = [];         % remove those which are corresponding to NaN
        sddistTemp(idxLOF) = [];
    end
    
    counter = 1;
    for ii=1:source;
        for jj=1:detect;
            if pairsTemp(ii,jj) == 1
                found = find(idxLOF == counter);
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
return