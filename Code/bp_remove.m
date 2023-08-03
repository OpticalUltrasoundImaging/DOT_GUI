 

function [sddist,A_m,P_m,pairs,Measmnt,phase,amp_log] = bp_remove(BadPoints,sddist,A_m,P_m,...
    Measmnt,pairs,phase,amp_log,source,detect)

    for i=1:length(BadPoints)
        k=BadPoints(i);
        %Mark the places of the badpoints within the vectors with 0's
        sddist(k) = 0;
        A_m(k) = 0;
        P_m(k) = 0;
        amp_log(k) = 0;
        phase(k) = 0;
        
        %Remove the indices of the badpoints from the pairsarray
        x=Measmnt(k,:);
        pairs(x(1),x(2)) = 0; 
    end

    %Create new vectors, minus the badpoints
    sddist=nonzeros(sddist)'; 
    A_m = nonzeros(A_m)';
    P_m = nonzeros(P_m)';
    amp_log=nonzeros(amp_log)';
    phase=nonzeros(phase)';
        
    %Create new Measmnt matrix
    k=0;
    Measmnt=[];
    for ii=1:source
        for jj=1:detect
            if pairs(ii,jj)== 1
                k=k+1;
                Measmnt(k,1) = ii; 
                Measmnt(k,2) = jj; 
            end
        end
    end
    
    


                