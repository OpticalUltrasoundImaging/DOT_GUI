

function [P_m,phase,amp_log,corr_ki,corr_kr,muabg,muspbg,muabga,muspbga] = phase_shift(phase_axis,ShiftPoints,...
    p1,P_m,A_m,amp_log,sddist,Measmnt,pairs,source,detect,sddist_matrix,s_geom,d_geom,bga,bgp,aba,abp,phase,...
    muabg,muspbg,corr_ki,corr_kr,freq,Refl)


vel_c = 2.99792458e+10; %speed of light in vacum in cm
%freq = 50; %modulation frequency MHz
semi_inf = 1; %semi_infinite weights
n_ref = 1.3333; %refractive index in medium
vel = vel_c/n_ref; %speed of light in medium in cm
omega = 2.0*pi*freq*1000000; %2pi freq


switch phase_axis
    case 'cali_axes_phase' 
        %P_m
       % ShiftPoints
        for i=1:length(ShiftPoints)
            k=ShiftPoints(i);
            if p1 == 1 %User has chosen +2pi
                P_m(k) = P_m(k)+(2*pi);
            else %User has chosen -2pi
                P_m(k) = P_m(k)-(2*pi);
            end
        end
        
        %Re-do the calibration and fitting with the phase shifted values
        
        [muabg,muspbg,muabga,muspbga,corr_ki,corr_kr,amp_log,phase] = recal_refit(phase_axis,...
            sddist,Measmnt,pairs,source,detect,sddist_matrix,s_geom,d_geom,A_m,P_m,amp_log,phase,corr_ki,...
            corr_kr,bga,bgp,aba,abp,freq,Refl);
        
                         
        
    case 'fit_axes_phase' %For fit_axes_phase
        
         for i=1:length(ShiftPoints)
            k=ShiftPoints(i);
            if p1 == 1 %User has chosen +2pi
                phase(k) = phase(k)+(2*pi);
            else %User has chosen -2pi
                phase(k) = phase(k)-(2*pi);
            end
         end
                                             
        temp = polyfit(sddist,amp_log,1);
        kia=-temp(1)/corr_ki;

        %phase=unwrap(phase);
   
        temp = polyfit(sddist,phase,1);
        kra=temp(1)/corr_kr;
      
        Da = omega/2/kia/kra/vel;
        muabga =-(-kia^2+kra^2)*Da;
        muspbga = 1/3/Da;
end
        
        Rsddist_amp=[];
        Rsddist_phase=[];
        
        avesd=mean(sddist);
        aveamp=mean(amp_log);
        avephase=mean(phase);

        lsddist=(sddist-avesd)*(sddist-avesd)';
        lamp=(amp_log-aveamp)*(amp_log-aveamp)';
        lphase=(phase-avephase)*(phase-avephase)';
        lsddist_amp=(sddist-avesd)*(amp_log-aveamp)';
        lsddist_phase=(sddist-avesd)*(phase-avephase)';

        Rsddist_amp=-lsddist_amp/(sqrt(lsddist*lamp));
        Rsddist_phase=lsddist_phase/(sqrt(lsddist*lphase));



    