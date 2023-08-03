function [regks] = regShaped(depth_info, data, app, source_wvl)
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
width_measure = [1,Nd];
if source_wvl == 740
    MeasureApp = measure(app,width_measure);
    waitfor(MeasureApp)
    if width_measure(end) == 1
        width_info = [app.width1];
    elseif width_measure(end) == 2
        width_info = [app.width1,app.width2];
    elseif width_measure(end) == 3
        width_info = [app.width1,app.width2,app.width3];
    elseif width_measure(end) == 4
        width_info = [app.width1,app.width2,app.width3,app.width4];
    elseif width_measure(end) == 5
        width_info = [app.width1,app.width2,app.width3,app.width4,app.width5];
    end
    
    if isempty(width_info)
        errordlg('Cannot find width infomation, please try again','ERROR');
        return
    end
else
    if width_measure(end) == 1
        width_info = [app.width1];
    elseif width_measure(end) == 2
        width_info = [app.width1,app.width2];
    elseif width_measure(end) == 3
        width_info = [app.width1,app.width2,app.width3];
    elseif width_measure(end) == 4
        width_info = [app.width1,app.width2,app.width3,app.width4];
    elseif width_measure(end) == 5
        width_info = [app.width1,app.width2,app.width3,app.width4,app.width5];
    end
end

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