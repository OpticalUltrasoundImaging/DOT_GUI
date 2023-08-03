clear amp80_log;
clear amp80;
clear phase80;
clear sddist80;

% pairs80=pairs;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% form aba amplitude & phase %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   
amp80=[];
phase80=[];

mi=0;
p=0;
for si=1:source
    for di=1:detect
      rho=sddist_matrix(si,di);
      if rho>turnpoint
         
          if pairs80(si,di)
             mi=mi+1;
             p=p+1;
          	 amp80(p)=aba_r80(si,di)/corr_a80(mi)/AS80(si)/AD80(di);
             phase80(p)=abp_r80(si,di)-corr_p80(mi)-PS80(si)-PD80(di);
             sddist80(p)=sddist_matrix(si,di);
             Measmnt80(p,2)=di;
             Measmnt80(p,1)=si;
            
             amp80_log(p)=log(amp80(p)*rho^2);


              
              end
           end
    
     end
    
end

%phase7 = mod(phase7+2,2*pi)-2;
%phase8 = mod(phase8+2,2*pi)-2;

%obtaining kr, ki by fitting 

   temp = polyfit(sddist80,amp80_log,1);
   ki80a=-temp(1)/corr_ki80;
   %phase80=unwrap(phase80);
   temp = polyfit(sddist80,phase80,1);
   kr80a=temp(1)/corr_kr80;
   
   
D80a = omega/2/ki80a/kr80a/vel;
muabg80a =-(-ki80a^2+kr80a^2)*D80a;
muspbg80a = 1/3/D80a;

x=find(pairs80>0);
Nmeas80=length(x);


avesd=mean(sddist80);
aveamp80=mean(amp80_log);
avephase80=mean(phase80);

lsddist80=(sddist80-avesd)*(sddist80-avesd)';
lamp80=(amp80_log-aveamp80)*(amp80_log-aveamp80)';
lphase80=(phase80-avephase80)*(phase80-avephase80)';
lsddist80_amp=(sddist80-avesd)*(amp80_log-aveamp80)';
lsddist80_phase=(sddist80-avesd)*(phase80-avephase80)';

Rsddist_amp80=-lsddist80_amp/(sqrt(lsddist80*lamp80));
Rsddist_phase80=lsddist80_phase/(sqrt(lsddist80*lphase80));

 




   
