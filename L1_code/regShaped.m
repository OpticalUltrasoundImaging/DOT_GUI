function [regks] = regShaped(depth_info, data)
% This code output the regularization parameter for reconstruction used in
% shaped based reconstruction.
% Based on US images to get shape information and apply in reconstruction

% Currently: Hard coding it.
% Furthuer, used NN to get shape information
%% basic setting
dataNorm = norm(data);
regParam = 2e-2;
Nd = length(depth_info);

%% width information
width_info = [0.86,1.70,1.47];
%%
%probeSize = 5.2;
if Nd == 1
    regWeight = 2;
    d = regWeight * width_info;
elseif Nd == 2
    regWeight = [0.5,2];
    d = regWeight.*width_info;
elseif Nd == 3
    regWeight = [0.5,2,0.5];
    %regWeight = [0.25,2,0.5];
    d = regWeight.*width_info;
elseif Nd == 4
    regWeight = [0.5,2,2,0.5];
    d = regWeight.*width_info;
elseif Nd == 5
    regWeight = [0.5,2,4,2,0.5];
    d = regWeight.*width_info;
end
%% Get regularization parameters
regks = zeros(Nd,1);
for idx = 1:Nd
    regks(idx) = regParam/(d(idx)^2)*dataNorm;
end
end