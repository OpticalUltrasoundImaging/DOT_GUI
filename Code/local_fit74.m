clear amp74_log;
clear amp74;
clear phase74;
clear phase8;
clear sddist74;

% pairs74=pairs;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% form aba amplitude & phase %%%%%%%%%%
amp74=[];
phase74=[];

mi=0;
p=0;
for si=1:source
    for di=1:detect
      rho=sddist_matrix(si,di);
      if rho>turnpoint
         
          if pairs74(si,di)
            mi=mi+1;
            p=p+1;
        	   amp74(p)=aba_r74(si,di)/corr_a74(mi)/AS74(si)/AD74(di);
            phase74(p)=abp_r74(si,di)-corr_p74(mi)-PS74(si)-PD74(di);
            sddist74(p)=sddist_matrix(si,di);
            Measmnt74(p,2)=di;
            Measmnt74(p,1)=si;
            
            amp74_log(p)=log(amp74(p)*rho^2);
            
            %phase74(p)=mod(phase74(p),2*pi);
   
              
               
%                   if(sddist74(p)>74.4)
%                       p=p-1;
%                       
%                    
%                     pairs74(si,di)=0;
%                   
%                   end
%                   if(phase74(p)>1.1&sddist74(p)<3.5)
%                      p=p-1;
%                      pairs74(si,di)=0;
%                      
%                      end
              
               
           end
           end;
 end;
    
end

%phase7 = mod(phase7+2,2*pi)-2;
%phase8 = mod(phase8+2,2*pi)-2;

%obtaining kr, ki by fitting 

   temp = polyfit(sddist74,amp74_log,1);
   ki74a=-temp(1)/corr_ki74;
   %phase74 = unwrap(phase74);
 
   temp = polyfit(sddist74,phase74,1);
   kr74a=temp(1)/corr_kr74;
   
   
D74a = omega/2/ki74a/kr74a/vel;
muabg74a =-(-ki74a^2+kr74a^2)*D74a;
muspbg74a = 1/3/D74a;

x=find(pairs74>0);
Nmeas74=length(x);

avesd=mean(sddist74);
aveamp74=mean(amp74_log);
avephase74=mean(phase74);

lsddist74=(sddist74-avesd)*(sddist74-avesd)';
lamp74=(amp74_log-aveamp74)*(amp74_log-aveamp74)';
lphase74=(phase74-avephase74)*(phase74-avephase74)';
lsddist74_amp=(sddist74-avesd)*(amp74_log-aveamp74)';
lsddist74_phase=(sddist74-avesd)*(phase74-avephase74)';

Rsddist_amp74=-lsddist74_amp/(sqrt(lsddist74*lamp74));
Rsddist_phase74=lsddist74_phase/(sqrt(lsddist74*lphase74));

 




   
