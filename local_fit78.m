clear amp78_log;
clear amp78;
clear phase78;
clear sddist78;

% pairs78=pairs;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% form aba amplitude & phase %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   
amp78=[];
phase78=[];

mi=0;
p=0;
for si=1:source
    for di=1:detect
      rho=sddist_matrix(si,di);
      if rho>turnpoint
         
          if pairs78(si,di)
             mi=mi+1;
             p=p+1;
          	 amp78(p)=aba_r78(si,di)/corr_a78(mi)/AS78(si)/AD78(di);
             phase78(p)=abp_r78(si,di)-corr_p78(mi)-PS78(si)-PD78(di);
             sddist78(p)=sddist_matrix(si,di);
             Measmnt78(p,2)=di;
             Measmnt78(p,1)=si;
            
             amp78_log(p)=log(amp78(p)*rho^2);

             %phase7(p)=phase7(p)+2*pi;
%                if(sddist7(p)>6.4)
%                       p=p-1;
%                       
%                    
%                     pairs7(si,di)=0;
%                end
              % if(amp7_log(p)<-7.5)
                  % p=p-1;
                   %pairs7(si,di)=0;
              % end
               
              
              
              end
           end
    
     end
    
end

%phase7 = mod(phase7+2,2*pi)-2;
%phase8 = mod(phase8+2,2*pi)-2;

%obtaining kr, ki by fitting 

   temp = polyfit(sddist78,amp78_log,1);
   ki78a=-temp(1)/corr_ki78;
   %phase78=unwrap(phase78);
   temp = polyfit(sddist78,phase78,1);
   kr78a=temp(1)/corr_kr78;
   
   
D78a = omega/2/ki78a/kr78a/vel;
muabg78a =-(-ki78a^2+kr78a^2)*D78a;
muspbg78a = 1/3/D78a;

x=find(pairs78>0);
Nmeas78=length(x);


avesd=mean(sddist78);
aveamp78=mean(amp78_log);
avephase78=mean(phase78);

lsddist78=(sddist78-avesd)*(sddist78-avesd)';
lamp78=(amp78_log-aveamp78)*(amp78_log-aveamp78)';
lphase78=(phase78-avephase78)*(phase78-avephase78)';
lsddist78_amp=(sddist78-avesd)*(amp78_log-aveamp78)';
lsddist78_phase=(sddist78-avesd)*(phase78-avephase78)';

Rsddist_amp78=-lsddist78_amp/(sqrt(lsddist78*lamp78));
Rsddist_phase78=lsddist78_phase/(sqrt(lsddist78*lphase78));

 




   
