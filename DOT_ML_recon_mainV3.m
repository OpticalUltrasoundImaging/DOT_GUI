% Load perturbation mat file and output the mat file used in Python code to
% reconstruction the lesion
% Menghao Zhang 2021/11/02, Modified by 03/21/2022
% Only suitbale for Washu geometry: s9d14_sys4_3WU2 and 

% Description for the output of this code:
% Output variabels name: recon_figure, recon_para

% Output contains two parts, the first part (recon_figure) contrains reconstructed mua map and 
% the hemoglobin concentration maps. Each map is a 7 by 37 by 37 by 7 matrix.
% For the first 4 maps, these are the reconstructed mua maps (one for each wavlength)
% use colorbar [0,0.2]
% For the last 3 map,s these are the hemoglobin concentration maps 
% (the sequence is hemo, oxy and deoxy) use colorbar [0, 100].

% The second part (recon_para) is the maximum value and the mean value of the FWHM for
% each reconstructed images, which is a 5 by 2 matrix. The first column is
% maximum value and the second column is the mean value of the FWHM.

%% If points got deleted, add zero to back 1 by 126 vector.
meas_all = zeros(126,2);
i=1;
for s_idx = 1:9
    for d_idx = 1:14
        meas_all(i,:) = [s_idx,d_idx];
        i = i + 1;
    end
end
targetFileSelected = 1;
% 740 nm
if app.KmeansOutliersRemovalCheckBox.Value
    origin_pert74 = targetFileStruct(targetFileSelected).pert740;
    t_meas74 = targetFileStruct(targetFileSelected).Measmnt740;
elseif app.LOFRemovalCheckBox.Value
    origin_pert74 = targetFileStruct(targetFileSelected).pert740L;
    t_meas74 = targetFileStruct(targetFileSelected).Measmnt740L;
elseif app.ELPRemovalCheckBox.Value
    origin_pert74 = targetFileStruct(targetFileSelected).pert740E;
    t_meas74 = targetFileStruct(targetFileSelected).Measmnt740E;
else
    origin_pert74 = targetFileStruct(targetFileSelected).pert740A;
    t_meas74 = targetFileStruct(targetFileSelected).Measmnt740A;
end

% Add data back to 1 * 126;
input_pert74 = zeros(1,126);

for idx = 1:126
    temp = meas_all(idx,:);
    [tf,index] = ismember(temp,t_meas74,'row');
    if tf == 1
        input_pert74(idx) = origin_pert74(index);
    end
end

% 780 nm
if app.KmeansOutliersRemovalCheckBox.Value
    origin_pert78 = targetFileStruct(targetFileSelected).pert780;
    t_meas78 = targetFileStruct(targetFileSelected).Measmnt780;
elseif app.LOFRemovalCheckBox.Value
    origin_pert78 = targetFileStruct(targetFileSelected).pert780L;
    t_meas78 = targetFileStruct(targetFileSelected).Measmnt780L;
elseif app.ELPRemovalCheckBox.Value
    origin_pert78 = targetFileStruct(targetFileSelected).pert780E;
    t_meas78 = targetFileStruct(targetFileSelected).Measmnt780E;
else
    origin_pert78 = targetFileStruct(targetFileSelected).pert780A;
    t_meas78 = targetFileStruct(targetFileSelected).Measmnt780A;
end
% Add data back to 1 * 126;
input_pert78 = zeros(1,126);

for idx = 1:126
    temp = meas_all(idx,:);
    [tf,index] = ismember(temp,t_meas78,'row');
    if tf == 1
        input_pert78(idx) = origin_pert78(index);
    end
end

% 808 nm
if app.KmeansOutliersRemovalCheckBox.Value
    origin_pert80 = targetFileStruct(targetFileSelected).pert808;
    t_meas80 = targetFileStruct(targetFileSelected).Measmnt808;
elseif app.LOFRemovalCheckBox.Value
    origin_pert80 = targetFileStruct(targetFileSelected).pert808L;
    t_meas80 = targetFileStruct(targetFileSelected).Measmnt808L;
elseif app.ELPRemovalCheckBox.Value
    origin_pert80 = targetFileStruct(targetFileSelected).pert808E;
    t_meas80 = targetFileStruct(targetFileSelected).Measmnt808E;
else
    origin_pert80 = targetFileStruct(targetFileSelected).pert808A;
    t_meas80 = targetFileStruct(targetFileSelected).Measmnt808A;
end
% Add data back to 1 * 126;
input_pert80 = zeros(1,126);

for idx = 1:126
    temp = meas_all(idx,:);
    [tf,index] = ismember(temp,t_meas80,'row');
    if tf == 1
        input_pert80(idx) = origin_pert80(index);
    end
end

% 830 nm
if app.KmeansOutliersRemovalCheckBox.Value
    origin_pert83 = targetFileStruct(targetFileSelected).pert830;
    t_meas83 = targetFileStruct(targetFileSelected).Measmnt830;
elseif app.LOFRemovalCheckBox.Value
    origin_pert83 = targetFileStruct(targetFileSelected).pert830L;
    t_meas83 = targetFileStruct(targetFileSelected).Measmnt830L;
elseif app.ELPRemovalCheckBox.Value
    origin_pert83 = targetFileStruct(targetFileSelected).pert830E;
    t_meas83 = targetFileStruct(targetFileSelected).Measmnt830E;
else
    origin_pert83 = targetFileStruct(targetFileSelected).pert830A;
    t_meas83 = targetFileStruct(targetFileSelected).Measmnt830A;
end
% Add data back to 1 * 126;
input_pert83 = zeros(1,126);

for idx = 1:126
    temp = meas_all(idx,:);
    [tf,index] = ismember(temp,t_meas83,'row');
    if tf == 1
        input_pert83(idx) = origin_pert83(index);
    end
end
if s_geom(1,2) == 4.012 
    input_pert74 = (reshape(input_pert74,detect,source)).';
    input_pert74 =  input_pert74([3 5 7 9 2 4 6 8 1],[5 1 8 12 6 2 14 9 7 10 3 13 4 11]);  
    input_pert74 = reshape(input_pert74.',[1,detect*source]);  
    input_pert78 = (reshape(input_pert78,detect,source)).';
    input_pert78 =  input_pert78([3 5 7 9 2 4 6 8 1],[5 1 8 12 6 2 14 9 7 10 3 13 4 11]);  
    input_pert78 = reshape(input_pert78.',[1,detect*source]);  
    input_pert80 = (reshape(input_pert80,detect,source)).';
    input_pert80 =  input_pert80([3 5 7 9 2 4 6 8 1],[5 1 8 12 6 2 14 9 7 10 3 13 4 11]);  
    input_pert80 = reshape(input_pert80.',[1,detect*source]);  
    input_pert83 = (reshape(input_pert83,detect,source)).';
    input_pert83 =  input_pert83([3 5 7 9 2 4 6 8 1],[5 1 8 12 6 2 14 9 7 10 3 13 4 11]);  
    input_pert83 = reshape(input_pert83.',[1,detect*source]);  
end 
% Other parameter
depth = ones(4,1) * depth;
radius = ones(4,1) * z_radius;

% Combined input data together
mua4Wv = [mua074;mua078;mua080;mua083];
musp4Wv = [mus074;mus078;mus080;mus083];

input_data = [input_pert74;input_pert78;input_pert80;input_pert83];
input_data = [real(input_data),imag(input_data),depth,radius,mua4Wv,musp4Wv];
waitbar(.4,f,'Please wait for DOT ML results ...');
%% Call python
% input_data = load('input_data.mat');
% a = input_data.input_data;
output = double(py.DOT_AE_final_V2.ML_DOT_recon_main(py.numpy.array(input_data)));

%% Post_processing
% The output is following the form of 33 by 33 by 7. But to keep
% consistency with other algorithm, padding them into 37 by 37 by 7.
% Arrange output all into 37 by 37 by 7 form
mua0_4wavelength = input_data(:,255);
recon_mua_figure = zeros(4,37,37,7);
for wave_idx = 1:4
    recon_mua_figure(wave_idx,:,:,:) = recon_mua_figure(wave_idx,:,:,:) + mua4Wv(wave_idx);
    B = reshape(output(wave_idx,:), 33,33,7);
    %Smooth
	B = smoothdata(B,'movmean',[2 2]);
    B1 = zeros(33,33,7); 
    B1(1:32,:,:) = B(2:33,:,:);
    B2 = zeros(33,33,7); 
    B2(:,1:32,:) = B(:,2:33,:);
    B3 = zeros(33,33,7); 
    B3(1:32,1:32,:) = B(2:33,2:33,:);
    B_s = (B+B1+B2+B3)/4;
%     C = zeros(33,33,7) + mua0_4wavelength(wave_idx);
    C = B_s + mua0_4wavelength(wave_idx);
    recon_mua_figure(wave_idx,3:35,3:35,:) = C;
end
waitbar(.6,f,'Please wait for DOT ML results ...');
% Coumpute the hemoglobin saturation following the code oxy_map and oxy_total 
volume74 = squeeze(recon_mua_figure(1,:,:,:));
volume78 = squeeze(recon_mua_figure(2,:,:,:));
volume80 = squeeze(recon_mua_figure(3,:,:,:));
volume83 = squeeze(recon_mua_figure(4,:,:,:));

% 4 wavelengths mua reconstruction
[absMax74, absMean74, ~] = absorp_tot(volume74(:),37*37*7,0);
[absMax78, absMean78, ~] = absorp_tot(volume78(:),37*37*7,0);
[absMax80, absMean80, ~] = absorp_tot(volume80(:),37*37*7,0);
[absMax83, absMean83, ~] = absorp_tot(volume83(:),37*37*7,0);
