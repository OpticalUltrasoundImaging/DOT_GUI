function [dMua_tot,object]=conj_TLS_regularized(dMua_tot,data,weight_a,NmeasT,Nvxls,v_vol_L,v_vol_N,mua0,mus0,v_tot,itmax,epsPercent,removePhase)
% ---- conjugate gradient method

min_mua = -0.005*mua0;
max_mua = 1;

% epsPercent, default is 0.01
% itmax, default is 5

%itmax = 5;
% X = sprintf('conj_TLS_regularized itmax is %s', num2str(itmax));
% disp(X);

% ---- starting model
% Nmod = Nvxls;
modnew = dMua_tot;  % dMua_tot=zeros(Nvxls,1);
g(1:NmeasT,1:Nvxls)=real(weight_a');
if removePhase == 0
    g((NmeasT+1):(2*NmeasT),1:Nvxls)=imag(conj(weight_a'));
end
% g = real(weight_a');
% data = data(1:NmeasT);
% g = abs(real(weight_a')+1i*imag(conj(weight_a')));
% data = abs(data(1:NmeasT)+1i*data(NmeasT+1:end));
singular_vals=svd(g);
%%%%%%%%%%%%%%%%%%%%%%%
% generate starting model which is not far away from the real one
modbest=modnew;
tmp1=g*modnew-data;
tmp1_2=tmp1'*tmp1;
mod_2=modnew'*modnew+1;
gamma_1=g'*tmp1;
object(1)=tmp1_2/(2*mod_2);

EPS=object(1);    %related to stopping criterion

% 2) conjugate gradient method

test=1; % if test=1, iterate!
iter=1;

iloop=1;
hessei_1=g'*g;
hessei_1=hessei_1+eye(length(hessei_1))*max(singular_vals);     %10*sigma_1 used as lambda

while test==1
    iloop=iloop+1;
    iloop_1=iloop-1;
    
    if iter==1
        gammanew=gamma_1/mod_2-tmp1_2*modnew/(mod_2^2);
        hessei=hessei_1/mod_2;
        hnew=-gammanew;
        hhold=hnew;
        gammaold=gammanew;
    end
    
    fret=-gammanew'*hnew/(hnew'*hessei*hnew);
    diff_mod=fret/2*hnew;
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
    
    if object(iloop)>=object(iloop_1)	%objective function doesn't change
         X = sprintf('conj_TLS_regularized number of iterations done before exit is %s', num2str(iloop));
       test=0;
    end

    %if abs(object(iloop_1)-object(iloop)) < epsPercent*EPS
      %  X = sprintf('conj_TLS_regularized number of iterations done before exit is %s', num2str(iloop));
      %  test =0;
    %end
    
    if object(iloop) < object(iloop_1)
        modbest = modnew;
    end
 
    X = sprintf('conj_TLS_regularized number of iterations is %s, itmax is %s, epsPercent is %s', num2str(iloop), num2str(itmax), num2str(epsPercent));
    disp(X);
    
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
        test = 0;
    end
    if iloop==itmax
        test=0;
    end
    
end % end of iter
iter

dMua_tot(1:v_tot)=modbest(1:v_tot)/v_vol_L;
dMua_tot(v_tot+1:Nvxls)=modbest(v_tot+1:Nvxls)/v_vol_N;
object