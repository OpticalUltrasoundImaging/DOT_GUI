function [dMua_tot,object] = Fista(dMua_tot,dataPert,A,NmeasT,Nvxls,v_vol_L, v_vol_N,v_tot,v_loc,regks,itmax,depth)

%% Initial value for FISTA
xhat = dMua_tot;
ss = dMua_tot;
qq = 1;
b = dataPert;
stepSize = 1/(norm(A*A'));
W = [real(A);imag(A)];
% Define object function
obj = zeros(itmax,1); % object function
obj(1) = 1/2*norm(W*ss-b)^2;
%% Define regularization parameters
nks = length(regks);
Nvc = Nvxls-v_tot;
regLambda = [];
for idx = 1:nks
    lambdaMatrix = regks(idx) * ones(length(v_loc{idx}),1);
    regLambda = [regLambda;lambdaMatrix];
end
lambda = diag([regLambda;zeros(Nvc,1)]);
% For shallow target, add more regularization to it.
if depth < 1.5
    lambda = lambda .* 2;
    regks = regks .* 2;
end
%% Determine the stop criteria

% Compute area and premeter of the covex hull of perturbation data
[Area,~,~,Premeter] = caculatePeriphery(dataPert(1:NmeasT),dataPert(NmeasT+1:end),0);
SpreadCoeff = Area*Premeter;
% if SpreadCoeff>3
%     SpreadCoeff = 3;
% end

% Compute real perturbation centers by k-means method
data = [dataPert(1:NmeasT),dataPert(NmeasT+1:end)];
% number of k in k-means algorithms
kcenters = 7;
[Cidx,C] = kmeans(data, kcenters);
Xcenters = C(:,1)';
kcount = zeros(1,kcenters);
for idx = 1:kcenters
   kcount(idx) = length(find(Cidx == idx));
end
%Number of points in one group will be considered useful. Current set is
%1/10 of all points
ptNeeded = 4;
CountedIdx = find(kcount>ptNeeded);
% Computed centers by only using large group
realCenter = sum(kcount(CountedIdx) .* Xcenters(CountedIdx))./sum(kcount(CountedIdx));

% % Spread of the perturbation data
% % Based on k-mean results, get rid of some groups with very small number of
% % points (Currently, smaller than 3)
% OutlierDefine = 3;
% OutlierIdx = find(kcount<OutlierDefine);
% dataForHull = data(Cidx~=OutlierIdx,:);
% % Compute area and premeter of the covex hull of perturbation data
% [Area,~,~,Premeter] = caculatePeriphery(dataForHull(:,1),dataForHull(:,2),0);
% SpreadCoeff = Area*Premeter;
% if SpreadCoeff>3
%     SpreadCoeff = 3;
% end


% Compute the stop criteria based on spread of perturbation and the center
% of real perturbation.
% Determine value of I based on target size
if v_tot < 1000
    target_size = 1;
elseif v_tot < 2000
    target_size = 1.5;
elseif v_tot < 3000
    target_size = 2;
elseif v_tot < 3500
    target_size = 2.5;
else
    target_size = 3;
end

Ibased = floor(10/(3*target_size-2));
% Compute stop criteria based on data

EPS = 0.01 * obj(1) * SpreadCoeff * (Ibased^realCenter);

% Set maximum of minimum stop criteria
if EPS>0.05*obj(1)
    EPS=0.05*obj(1);
elseif EPS<0.001*obj(1)
    EPS=0.001*obj(1);
end

%% Iteration

test = 1;
iter = 1;
while test==1
    res = W*ss-b;
    obj(iter) = 1/2*norm(res)^2;%; + norm(lambda * ss,1);
    if iter>1
        % If data is good (object function is very low, then no need to
        % consider stop before maximum iteration
        if (obj(iter)>1.2)
            if (abs(obj(iter) - obj(iter-1))<EPS)
                test = 0;
            end
        end
    end
    zz = ss - stepSize*W'*res;
    xhatpre = xhat;
    xhat = zz;
    for idx = 1:nks
        xhat(v_loc{idx}) =  thre(xhat(v_loc{idx}),stepSize*regks(idx));
    end
    xhat(xhat<0) = 0;
    qqpre = qq;
    qq = 1/2*(1+sqrt(1+4*qq^2));
    ss = xhat+(qqpre-1)/qq*(xhat-xhatpre);
    if iter==itmax
        test=0;
    end
    if iter<5
        test = 1;
    end
    iter = iter+1;
end


projected_data=W*xhat;
error_data=(dataPert'-projected_data').^2;
projError=error_data(1:NmeasT)+error_data(NmeasT+1:end);
xhat(1:v_tot) = xhat(1:v_tot)/v_vol_L;

xhat(v_tot+1:end) = xhat(v_tot+1:end)/v_vol_N; 
dMua_tot = xhat;
object = obj(1:iter-1);
figure,plot(object)
%% Print some variables for documents. 
% Also have some plot
% Output variables documents
%disp('Start for one wavelength')
% Niter = iter-1
% regks
% objIni = obj(1)
% V = Ibased
% %disp('End for one wavelength')
% Plot k-mean results and perturbation data with unit circles
% theta = 0:0.001:2*pi;
% figure,
% plot(data(:,1),data(:,2),'r*'),hold on
% plot(C(:,1),C(:,2),'ko'),hold on
% plot(cos(theta),sin(theta)),hold off
% axis image
% figure,plot(object)

%% Output some results for measure shadowing effect
% This part only works for large target
% First separate mua and weight matrix to first half and second half
% top = v_loc{1};
% if length(v_loc) == 2
%     bottom = v_loc{2};
% elseif length(v_loc) == 3
%     bottom = [v_loc{2};v_loc{3}];
% end
% Atop = A(:,top);
% Wtop = [real(Atop);imag(Atop)];
% Abot = A(:,bottom);
% Wbot = [real(Abot);imag(Abot)];
% % 
% % % Compute Usd 
% % % Since both of them come from fine mesh area, so it can direct apply to
% mua_top = dMua_tot(top).*v_vol_L;
% mua_bot = dMua_tot(bottom).*v_vol_L;
% % Map back to Usd part
% Utop = Wtop * mua_top;
% Ubot = Wbot * mua_bot;
% % Compute ratio for all of them
% % Two different ways to compute the ratio
% % 1: Sum them take absolute value
% % 2: Take absolute value them sum
% topSum1 = abs(sum(Utop));
% botSum1 = abs(sum(Ubot));
% ratio1 = topSum1/botSum1;
% topSum2 = sum(abs(Utop));
% botSum2 = sum(abs(Ubot));
% ratio2 = topSum2/botSum2;
% ratioUsd = [ratio1,ratio2]
% 
% mua_top = sum(mua_top, 'all');
% mua_bottom = sum(mua_bot, 'all');
% mua_ratio = mua_top / mua_bottom

% %% Second way to compute ratio is directly compute the mean of reconstruction values
% mua_top = dMua_tot(top);
% mua_bot = dMua_tot(bottom);
% % Two methods to compute mean value
% % 1, direct compute mean
% % 2, compute mean for FWHM values only
% meanTop1 = mean(mua_top);
% meanBot1 = mean(mua_bot);
% ratioMua1 = meanTop1/meanBot1;
% % Compute half max mean
% halfmaxTop = max(mua_top) /2;
% halfmaxBot = max(mua_bot)/2;
% % Then find those larger the FWHM
% fwTop = find(mua_top>halfmaxTop);
% fwBot = find(mua_bot>halfmaxBot);
% meanFWTop=mean(mua_top(fwTop));
% meanFWBot=mean(mua_bot(fwBot));
% ratioMua2 = meanFWTop/meanFWBot;
% ratioMua = [ratioMua1,ratioMua2]
% %% Documents maixmum mua ratio
% maxRatio = max(mua_top)/max(mua_bot)
end