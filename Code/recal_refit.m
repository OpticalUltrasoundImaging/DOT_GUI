%Recalibration of data after removal of badpoints

function [muabg,muspbg,muabga,muspbga,corr_ki,corr_kr,amp_log,phase,Rsddist_amp,Rsddist_phase] = recal_refit(selected_axis,...
    sddist,Measmnt,pairs,source,detect,sddist_matrix,s_geom,d_geom,A_m,P_m,amp_log,phase,corr_ki,corr_kr,bga,bgp,aba,abp,freq,...
    Refl)


pi=3.14159265358979; %pi
vel_c = 2.99792458e+10; %speed of light in vacum in cm
%freq = 50; %modulation frequency MHz
semi_inf = 1; %semi_infinite weights
n_ref = 1.3333; %refractive index in medium
vel = vel_c/n_ref; %speed of light in medium in cm
omega = 2.0*pi*freq*1000000; %2pi freq
pnts=256;
turnpoint=0;%2.5;   %one saturation point, maybe different for three wavelength

switch selected_axis
    %For the intralipid data
    case {'cali_axes_amp','cali_axes_phase'}

        mi = 0;
        MA=[];
        MP=[];

        for si=1:source
            for di=1:detect
                rho=sddist_matrix(si,di);
                bgamp(si,di)=bga(si,di);
                bgphase(si,di)=bgp(si,di);
                if pairs(si,di)
                    mi = mi+1;
                    MA=[MA; zeros(1,source+detect)];
                    MP=[MP; zeros(1,source+detect)];
                    if si>1
                        MA(mi,si-1)=1;
                        MP(mi,si-1)=1;
                    end
                    MA(mi,source+di-1)=1;
                    MP(mi,source+di-1)=1;
                    MA(mi,source+detect)=rho;
                    MP(mi,source+detect)=rho;
                end
            end
        end

        AF=MA\A_m';
        PF=MP\P_m';

        AS=[1;exp(AF(1:source-1))];
        AD=exp(AF(source:source+detect-1));

        PS=[0;PF(1:source-1)];
        PD=PF(source:source+detect-1);

        ki=-AF(source+detect);
        kr=PF(source+detect);

        D = omega/2/ki/kr/vel;
        muabg = -(-ki^2+kr^2)*D;
        muspbg = 1/3/D;


        U = bgpd(Measmnt,s_geom,d_geom,muabg,muspbg,freq,Refl);


        corr_a=[];
        corr_p=[];

        amp_m=[];
        phase_m=[];
        corr_ki=[];
        corr_kr=[];

        Nmeas = size(Measmnt,1);


        for jj=1:Nmeas
            si=Measmnt(jj,1);
            di=Measmnt(jj,2);
            phase_m(jj)=bgphase(si,di)-PS(si)-PD(di);
            amp_m(jj)=bgamp(si,di)/AS(si)/AD(di);
        end

        phase_m=mod(phase_m,2*pi);

        phase_c=angle(U);
        amp_c=abs(U);

        phase_diff=mean(mod((-phase_c+mod(phase_m,2*pi)+pi),2*pi)-pi);
        sys_gain=exp(mean(log(amp_m)-log(amp_c)));

        corr_a=amp_m./amp_c/sys_gain;
        corr_p=phase_m-phase_c-phase_diff;
        corr_p=mod(corr_p+1,2*pi)-1;

        temp = polyfit(sddist(1:Nmeas),log(amp_c.*sddist(1:Nmeas).^2),1);
        corr_ki = -temp(1)/ki;

        temp = polyfit(sddist(1:Nmeas),mod(phase_c,2*pi),1);
        corr_kr = temp(1)/kr;


        amp=[];
        phase=[];
        amp_log=[];

        mi=0;
        p=0;
        for si=1:source
            for di=1:detect
                rho=sddist_matrix(si,di);
                if rho>=turnpoint

                    if pairs(si,di)
                        mi=mi+1;
                        p=p+1;
                        amp(p)=aba(si,di)/sys_gain/corr_a(mi)/AS(si)/AD(di);
                        phase(p)=abp(si,di)-phase_diff-corr_p(mi)-PS(si)-PD(di);
                        amp_log(p)=log(amp(p)*rho^2);
                    end
                end
            end
        end

        temp = polyfit(sddist,amp_log,1);
        kia=-temp(1)/corr_ki;
        phase=unwrap(phase);
        temp = polyfit(sddist,phase,1);
        kra=temp(1)/corr_kr;
        Da = omega/2/kia/kra/vel;
        muabga =-(-kia^2+kra^2)*Da;
        muspbga = 1/3/Da;

        %For the reference tissue data
    case {'fit_axes_amp','fit_axes_phase'}

        mi = 0;
        MA=[];
        MP=[];

        for si=1:source
            for di=1:detect
                rho=sddist_matrix(si,di);
                if pairs(si,di)
                    mi = mi+1;
                    MA=[MA; zeros(1,source+detect)];
                    MP=[MP; zeros(1,source+detect)];
                    if si>1
                        MA(mi,si-1)=1;
                        MP(mi,si-1)=1;
                    end
                    MA(mi,source+di-1)=1;
                    MP(mi,source+di-1)=1;
                    MA(mi,source+detect)=rho;
                    MP(mi,source+detect)=rho;
                end
            end
        end


        AF=MA\A_m';
        PF=MP\P_m';
        ki=-AF(source+detect);
        kr=PF(source+detect);

        D = omega/2/ki/kr/vel;
        muabg = -(-ki^2+kr^2)*D;
        muspbg = 1/3/D;


        temp = polyfit(sddist,amp_log,1);
        kia=-temp(1)/corr_ki;

        phase=unwrap(phase);
        temp = polyfit(sddist,phase,1);
        kra=temp(1)/corr_kr;


        Da = omega/2/kia/kra/vel;
        muabga =-(-kia^2+kra^2)*Da;
        muspbga = 1/3/Da;


end

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









