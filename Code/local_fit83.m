clear amp83_log;
clear amp83;
clear phase83;
clear sddist83;

% pairs83=pairs;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% form aba amplitude & phase %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



amp83=[];
phase83=[];

mi=0;
p=0;
for si=1:source
    for di=1:detect
      rho=sddist_matrix(si,di);
      if rho>turnpoint
         
         if pairs83(si,di)
            mi=mi+1;
            p=p+1;
        	   amp83(p)=aba_r83(si,di)/corr_a83(mi)/AS83(si)/AD83(di);
            phase83(p)=abp_r83(si,di)-corr_p83(mi)-PS83(si)-PD83(di);
            sddist83(p)=sddist_matrix(si,di);
            Measmnt83(p,2)=di;
            Measmnt83(p,1)=si;
            
            amp83_log(p)=log(amp83(p)*rho^2);
             phase83(p)=phase83(p)+2*pi;
             
%                   if(sddist83(p)>6.4)
%                       p=p-1;
%                 
%                      pairs83(si,di)=0;
%                   end

                  
             
            
           
        end
     end;
  end;
    
end

%phase7 = mod(phase7+2,2*pi)-2;
%phase8 = mod(phase8+2,2*pi)-2;

%obtaining kr, ki by fitting 

   temp = polyfit(sddist83,amp83_log,1);
   ki83a=-temp(1)/corr_ki83;
   %phase83=unwrap(phase83);
   temp = polyfit(sddist83,phase83,1);
   kr83a=temp(1)/corr_kr83;
   
   
D83a = omega/2/ki83a/kr83a/vel;
muabg83a =-(-ki83a^2+kr83a^2)*D83a;
muspbg83a = 1/3/D83a;

x=find(pairs83>0);
Nmeas83=length(x);

avesd=mean(sddist83);
aveamp83=mean(amp83_log);
avephase83=mean(phase83);

lsddist83=(sddist83-avesd)*(sddist83-avesd)';
lamp83=(amp83_log-aveamp83)*(amp83_log-aveamp83)';
lphase83=(phase83-avephase83)*(phase83-avephase83)';
lsddist83_amp=(sddist83-avesd)*(amp83_log-aveamp83)';
lsddist83_phase=(sddist83-avesd)*(phase83-avephase83)';

Rsddist_amp83=-lsddist83_amp/(sqrt(lsddist83*lamp83));
Rsddist_phase83=lsddist83_phase/(sqrt(lsddist83*lphase83));

 




   
