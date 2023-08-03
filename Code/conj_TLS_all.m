function [dMua_tot]=conj_TLS_all(dMua_tot,data,weight_a,NmeasT,Nvxls,v_vol_L, v_vol_N,mua0,mus0,v_tot,itmax,epsPercent,removePhase)
% ---- conjugate gradient method

min_mua = -0.005*mua0;
max_mua = 1;
% itmax=4
% ---- starting model
modnew = dMua_tot;
g(1:NmeasT,1:Nvxls)=real(weight_a');
if removePhase == 0
    g((NmeasT+1):(2*NmeasT),1:Nvxls)=imag(conj(weight_a'));
end

%%%%%%%%%%%%%%%%%%%%%%%
% generate starting model which is not far away from the real one
modbest=modnew;
tmp1=g*modnew-data; %r0
tmp1_2=tmp1'*tmp1; %r0'*r0
mod_2=modnew'*modnew+1;
gamma_1=g'*tmp1;
object(1)=tmp1_2/(2*mod_2); % object

EPS=epsPercent*object(1);%related to stopping criterion

% conjugate gradient method
test=1;     % if test=1, iterate!
iter=1;
iloop=1;    % iloop starts with 1 but the loop actually starts with 2
hessei_1=g'*g;

while test==1
    iloop=iloop+1;  % loop actually starts with 2
   
    if iter==1;
        gammanew=gamma_1/mod_2-tmp1_2*modnew/(mod_2^2);
        hessei=hessei_1/mod_2;
        hnew=-gammanew;
        hhold=hnew;
        gammaold=gammanew;
    end
    
    fret=-gammanew'*hnew/(hnew'*hessei*hnew);
    if iloop == 3
        diff_mod=(fret)*hnew;
    else
        diff_mod=(fret)*hnew;
    end
%     diff_mod=(fret)*hnew; % change the step size here
    modnew=modnew+diff_mod;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%add constrains on model%%%%%%%%%%%%%%%%%%%
    dMua_tot=modnew(1:Nvxls,1);
    
    for v=1:Nvxls
        %impose  constraints
        if dMua_tot(v) < min_mua
            dMua_tot(v) = min_mua;
        elseif dMua_tot(v) > max_mua
            dMua_tot(v) = max_mua;
        end
        
    end %end of v loop
    
    modnew=dMua_tot;
    tmp1=g*modnew-data;
    tmp1_2=tmp1'*tmp1;
    mod_2=modnew'*modnew+1;
    gamma_1=g'*tmp1;
    object(iloop)=tmp1_2/(2*mod_2);
    
    X = sprintf('conj_TLS number of iterations is %s', num2str(iloop));
    disp(X);
    
    modbest=modnew;
    
    gammanew=gamma_1/mod_2-tmp1_2*modnew/(mod_2^2); % gamma --gradient
    hessei=hessei_1/mod_2;
    gam=(gammanew'-gammaold')*gammanew*(1d+10)/(gammaold'*gammaold*(1d+10));
    hnew=-gammanew+gam*hhold;
    hhold=hnew;
    gammaold=gammanew;
    
    if hnew'*gammanew < 0    %(right search direction)
        iter=iter+1;
    else
        iter=1;
    end
    
    if object(iloop) < epsPercent*EPS
        test=0;
    end
    if iloop == itmax
        test=0;
    end
    
end % end of iter
iter

dMua_tot(1:v_tot)=modbest(1:v_tot)/v_vol_L;
dMua_tot(v_tot+1:Nvxls)=modbest(v_tot+1:Nvxls)/v_vol_N;
object
% figure,plot(object)