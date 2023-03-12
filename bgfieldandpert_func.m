function [pert74,data74,Nmeas74new,Measmnt74new,sddist74new,pairs74New] = bgfieldandpert_func(source,detect,sddist_matrix,pairs74,aba74,abp74,bga74,bgp74,Measmnt74)
% aba74,abp74,bga74,bgp74 are target amplitude, target phase, reference amplitude and reference phase
amp74=[];
phase74=[];

if ~iscell(pairs74)         % pairs was filtered(set to 0) before by smoothing phase(smooth & smooth2)
    pairs74 = {pairs74};
end

% uses reference amplitude and reference phase
mi=0;
for si=1:source
    for di=1:detect
        if pairs74{end}(si,di)
            mi=mi+1;
            amp74(mi)=bga74(si,di);
            phase74(mi)=bgp74(si,di);
            sddist74(mi)=sddist_matrix(si,di);
        end
    end
end

U74a=amp74.*exp(1i*(phase74));	% uses reference amplitude and reference phase

amp74=[];
phase74=[];

% uses target amplitude, target phase
mi=0;
for si=1:source
    for di=1:detect
        if pairs74{end}(si,di)
            mi=mi+1;
            amp74(mi)=aba74(si,di);
            phase74(mi)=abp74(si,di);
        end
    end
end

pert74 =-(-amp74.*exp(1i*(phase74))+U74a)./U74a;
Measmnt74new = Measmnt74;
Nmeas74new = size(Measmnt74new,1);
sddist74new = sddist74;
pairs74New = pairs74{end};

removePertIdx = find(real(pert74) < -10);
removePertIdx1 = find(abs(U74a) < 0.000000001);
removePertIdx = unique([removePertIdx removePertIdx1]);

if ~isempty(removePertIdx)

    %Remove the indices of the badpoints from the pairs array.  pairs was filtered(set to 0) before by smoothing phase(smooth & smooth2)
    counter = 1;
    for ii=1:source;
        for jj=1:detect;
            if pairs74{end}(ii,jj) == 1
                found = find(removePertIdx == counter);
                if ~isempty(found)
                    pairs74New(ii,jj) = 0;
                end
                counter = counter + 1;
            end
        end
    end
    
    pert74(removePertIdx) = [];
    Measmnt74new(removePertIdx,:) = [];
    sddist74new(removePertIdx) = [];
    Nmeas74new = size(Measmnt74new,1);
end

data74 = [real(pert74) imag(pert74)];

pert74={pert74};
data74={data74};
Measmnt74new = {Measmnt74new};
Nmeas74new = {Nmeas74new};
sddist74new = {sddist74new};
pairs74New = {pairs74New};
