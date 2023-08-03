
function [STDA,STDP] = stand_dev(sddist,amp,phase)

format('short')
[temp1 temp2] = polyfit(sddist,amp,1); 
y=temp1(1)*sddist+temp1(2);
    
for i=1:length(sddist)
    normy(i)=(amp(i)-y(i))/y(i);
end
    
STDA=sum(normy.*normy);




[temp3 temp4] = polyfit(sddist,phase,1);
y=temp3(1)*sddist+temp3(2);
    
for i=1:length(sddist)
    normy(i)=(phase(i)-y(i))/y(i);
end   

%plot(sddist6,phase6,'o')
STDP=sum(normy.*normy);




