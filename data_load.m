function [tar_alldata, ref_alldata, intra_alldata] = data_load(mode, tar_data_path, ref_data_path, intra_data_path, tar_nLesion, ref_nLesion, intra_nLesion, source, detect, sddist_matrix)
%Reference: Simultaneous near-infrared diffusive light and ultrasound
%imaging, NG Chen, Section III(Method) Part B Experiments Systems

% Automatically choose reference based on overlapping
% Compute point-wise relative difference between two references and make decision
% based on the point-wise distance

%% Input and output information
% Output: isMotion: n by 1 vector, n is the number of lesion data sets vector,
%         to demonstrate whether exist motion or not.
% Input: nLesion: number of lesion data sets we have
%        meanTol: mean relative difference tolerance for motion detection,
%        a rough and not sensitive detection
%        ptDiffTol: a point-wise absolute difference to decided whether one
%        source-detector pair measurement change or not during two sets of
%        data
%        badptTol: maximun number of bad pts can one source have, if one
%        source has larger than this, than will be marked as motion.

%% Load data
% store the calibrated data for perturbation
f = waitbar(0,'Please wait...');
pause(0.5)
waitbar(.05,f,'Loading target...');
% if all data are not good, adjust threshold and repeat
tar_per = 0.28/tar_nLesion;
for idx = 1:tar_nLesion
    waitbar(.05+tar_per*idx,f,'Loading target...');
    % Initial cell structure to store the data
    tarData1 = cell(4,1); % 4 wavelength for amplitude storage, no need for phase information
    tarData2 = cell(4,1);
    tarData3 = cell(4,1);
    % Get file name of these three data sets
    filename1 = tar_data_path{3*idx-2};
    filename2 = tar_data_path{3*idx-1};
    filename3 = tar_data_path{3*idx};
    %%  Load txt file and put into data structure
    % Data set 1
    bgdata=textread(filename1); %Reading raw data %Source and Detector geometry
    if mode == 1
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_WashU(bgdata,source,detect,sddist_matrix);
    elseif mode == 2
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_UConn(bgdata,source,detect,sddist_matrix);
    elseif mode == 3
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_sys4_FPGA_ref_phase(bgdata,source,detect,sddist_matrix);
    else
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_sys6(bgdata,source,detect,0);
    end
    cali_amp74=log(sddist_matrix.^2.*amp74);
    cali_amp78=log(sddist_matrix.^2.*amp78);
    cali_amp80=log(sddist_matrix.^2.*amp80);
    cali_amp83=log(sddist_matrix.^2.*amp83);
    tarData1(1) = {cali_amp74};total_tarData1(idx,1) = {[reshape(amp74,1,[]),reshape(pha74,1,[])]};
    tarData1(2) = {cali_amp78};total_tarData1(idx,2) = {[reshape(amp78,1,[]),reshape(pha78,1,[])]};
    tarData1(3) = {cali_amp80};total_tarData1(idx,3) = {[reshape(amp80,1,[]),reshape(pha80,1,[])]};
    tarData1(4) = {cali_amp83};total_tarData1(idx,4) = {[reshape(amp83,1,[]),reshape(pha83,1,[])]};
    % Data set 2
    bgdata=textread(filename2); %Reading raw data %Source and Detector geometry
    if mode == 1
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_WashU(bgdata,source,detect,sddist_matrix);
    elseif mode == 2
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_UConn(bgdata,source,detect,sddist_matrix);
    elseif mode == 3
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_sys4_FPGA_ref_phase(bgdata,source,detect,sddist_matrix);
    else
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_sys6(bgdata,source,detect,0);
    end
    cali_amp74=log(sddist_matrix.^2.*amp74);
    cali_amp78=log(sddist_matrix.^2.*amp78);
    cali_amp80=log(sddist_matrix.^2.*amp80);
    cali_amp83=log(sddist_matrix.^2.*amp83);
    tarData2(1) = {cali_amp74};total_tarData2(idx,1) = {[reshape(amp74,1,[]),reshape(pha74,1,[])]};
    tarData2(2) = {cali_amp78};total_tarData2(idx,2) = {[reshape(amp78,1,[]),reshape(pha78,1,[])]};
    tarData2(3) = {cali_amp80};total_tarData2(idx,3) = {[reshape(amp80,1,[]),reshape(pha80,1,[])]};
    tarData2(4) = {cali_amp83};total_tarData2(idx,4) = {[reshape(amp83,1,[]),reshape(pha83,1,[])]};
    % Data set 3
    bgdata=textread(filename3); %Reading raw data %Source and Detector geometry
    if mode == 1
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_WashU(bgdata,source,detect,sddist_matrix);
    elseif mode == 2
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_UConn(bgdata,source,detect,sddist_matrix);
    elseif mode == 3
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_sys4_FPGA_ref_phase(bgdata,source,detect,sddist_matrix);
    else
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_sys6(bgdata,source,detect,0);
    end
    cali_amp74=log(sddist_matrix.^2.*amp74);
    cali_amp78=log(sddist_matrix.^2.*amp78);
    cali_amp80=log(sddist_matrix.^2.*amp80);
    cali_amp83=log(sddist_matrix.^2.*amp83);
    tarData3(1) = {cali_amp74};total_tarData3(idx,1) = {[reshape(amp74,1,[]),reshape(pha74,1,[])]};
    tarData3(2) = {cali_amp78};total_tarData3(idx,2) = {[reshape(amp78,1,[]),reshape(pha78,1,[])]};
    tarData3(3) = {cali_amp80};total_tarData3(idx,3) = {[reshape(amp80,1,[]),reshape(pha80,1,[])]};
    tarData3(4) = {cali_amp83};total_tarData3(idx,4) = {[reshape(amp83,1,[]),reshape(pha83,1,[])]};
    
end

%% reference side data
waitbar(.33,f,'Loading reference...');
ref_per = 0.33/ref_nLesion;
for idx = 1:ref_nLesion
    waitbar(.33+ref_per*idx,f,'Loading reference...');
    refData1 = cell(4,1); % 4 wavelength for amplitude storage, no need for phase information
    refData2 = cell(4,1);
    refData3 = cell(4,1);
    % Get file name of these three data sets
    filename1 = ref_data_path{3*idx-2};
    filename2 = ref_data_path{3*idx-1};
    filename3 = ref_data_path{3*idx};
    %%  Load txt file and put into data structure
    % Data set 1
    bgdata=textread(filename1); %Reading raw data %Source and Detector geometry
    if mode == 1
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_WashU(bgdata,source,detect,sddist_matrix);
    elseif mode == 2
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_UConn(bgdata,source,detect,sddist_matrix);
    elseif mode == 3
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_sys4_FPGA_ref_phase(bgdata,source,detect,sddist_matrix);
    else
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_sys6(bgdata,source,detect,0);
    end
    cali_amp74=log(sddist_matrix.^2.*amp74);
    cali_amp78=log(sddist_matrix.^2.*amp78);
    cali_amp80=log(sddist_matrix.^2.*amp80);
    cali_amp83=log(sddist_matrix.^2.*amp83);
    refData1(1) = {cali_amp74};total_refData1(idx,1) = {[reshape(amp74,1,[]),reshape(pha74,1,[])]};
    refData1(2) = {cali_amp78};total_refData1(idx,2) = {[reshape(amp78,1,[]),reshape(pha78,1,[])]};
    refData1(3) = {cali_amp80};total_refData1(idx,3) = {[reshape(amp80,1,[]),reshape(pha80,1,[])]};
    refData1(4) = {cali_amp83};total_refData1(idx,4) = {[reshape(amp83,1,[]),reshape(pha83,1,[])]};
    % Data set 2
    bgdata=textread(filename2); %Reading raw data %Source and Detector geometry
    if mode == 1
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_WashU(bgdata,source,detect,sddist_matrix);
    elseif mode == 2
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_UConn(bgdata,source,detect,sddist_matrix);
    elseif mode == 3
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_sys4_FPGA_ref_phase(bgdata,source,detect,sddist_matrix);
    else
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_sys6(bgdata,source,detect,0);
    end
    cali_amp74=log(sddist_matrix.^2.*amp74);
    cali_amp78=log(sddist_matrix.^2.*amp78);
    cali_amp80=log(sddist_matrix.^2.*amp80);
    cali_amp83=log(sddist_matrix.^2.*amp83);
    refData2(1) = {cali_amp74};total_refData2(idx,1) = {[reshape(amp74,1,[]),reshape(pha74,1,[])]};
    refData2(2) = {cali_amp78};total_refData2(idx,2) = {[reshape(amp78,1,[]),reshape(pha78,1,[])]};
    refData2(3) = {cali_amp80};total_refData2(idx,3) = {[reshape(amp80,1,[]),reshape(pha80,1,[])]};
    refData2(4) = {cali_amp83};total_refData2(idx,4) = {[reshape(amp83,1,[]),reshape(pha83,1,[])]};
    % Data set 3
    bgdata=textread(filename3); %Reading raw data %Source and Detector geometry
    if mode == 1
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_WashU(bgdata,source,detect,sddist_matrix);
    elseif mode == 2
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_UConn(bgdata,source,detect,sddist_matrix);
    elseif mode == 3
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_sys4_FPGA_ref_phase(bgdata,source,detect,sddist_matrix);
    else
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_sys6(bgdata,source,detect,0);
    end
    cali_amp74=log(sddist_matrix.^2.*amp74);
    cali_amp78=log(sddist_matrix.^2.*amp78);
    cali_amp80=log(sddist_matrix.^2.*amp80);
    cali_amp83=log(sddist_matrix.^2.*amp83);
    refData3(1) = {cali_amp74};total_refData3(idx,1) = {[reshape(amp74,1,[]),reshape(pha74,1,[])]};
    refData3(2) = {cali_amp78};total_refData3(idx,2) = {[reshape(amp78,1,[]),reshape(pha78,1,[])]};
    refData3(3) = {cali_amp80};total_refData3(idx,3) = {[reshape(amp80,1,[]),reshape(pha80,1,[])]};
    refData3(4) = {cali_amp83};total_refData3(idx,4) = {[reshape(amp83,1,[]),reshape(pha83,1,[])]};
end
%% intra data
waitbar(.66,f,'Loading intralipid...');
intra_per = 0.33/intra_nLesion;
for idx = 1:intra_nLesion
    waitbar(.66+intra_per*idx,f,'Loading intralipid...');
    intraData1 = cell(4,1); % 4 wavelength for amplitude storage, no need for phase information
    intraData2 = cell(4,1);
    intraData3 = cell(4,1);
    % Get file name of these three data sets
    filename1 = intra_data_path{3*idx-2};
    filename2 = intra_data_path{3*idx-1};
    filename3 = intra_data_path{3*idx};
    %%  Load txt file and put into data structure
    % Data set 1
    bgdata=textread(filename1); %Reading raw data %Source and Detector geometry
    if mode == 1
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_WashU(bgdata,source,detect,sddist_matrix);
    elseif mode == 2
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_UConn(bgdata,source,detect,sddist_matrix);
    elseif mode == 3
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_sys4_FPGA_ref_phase(bgdata,source,detect,sddist_matrix);
    else
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_sys6(bgdata,source,detect,0);
    end
    cali_amp74=log(sddist_matrix.^2.*amp74);
    cali_amp78=log(sddist_matrix.^2.*amp78);
    cali_amp80=log(sddist_matrix.^2.*amp80);
    cali_amp83=log(sddist_matrix.^2.*amp83);
    intraData1(1) = {cali_amp74};total_intraData1(idx,1) = {[reshape(amp74,1,[]),reshape(pha74,1,[])]};
    intraData1(2) = {cali_amp78};total_intraData1(idx,2) = {[reshape(amp78,1,[]),reshape(pha78,1,[])]};
    intraData1(3) = {cali_amp80};total_intraData1(idx,3) = {[reshape(amp80,1,[]),reshape(pha80,1,[])]};
    intraData1(4) = {cali_amp83};total_intraData1(idx,4) = {[reshape(amp83,1,[]),reshape(pha83,1,[])]};
    % Data set 2
    bgdata=textread(filename2); %Reading raw data %Source and Detector geometry
    if mode == 1
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_WashU(bgdata,source,detect,sddist_matrix);
    elseif mode == 2
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_UConn(bgdata,source,detect,sddist_matrix);
    elseif mode == 3
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_sys4_FPGA_ref_phase(bgdata,source,detect,sddist_matrix);
    else
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_sys6(bgdata,source,detect,0);
    end
    cali_amp74=log(sddist_matrix.^2.*amp74);
    cali_amp78=log(sddist_matrix.^2.*amp78);
    cali_amp80=log(sddist_matrix.^2.*amp80);
    cali_amp83=log(sddist_matrix.^2.*amp83);
    intraData2(1) = {cali_amp74};total_intraData2(idx,1) = {[reshape(amp74,1,[]),reshape(pha74,1,[])]};
    intraData2(2) = {cali_amp78};total_intraData2(idx,2) = {[reshape(amp78,1,[]),reshape(pha78,1,[])]};
    intraData2(3) = {cali_amp80};total_intraData2(idx,3) = {[reshape(amp80,1,[]),reshape(pha80,1,[])]};
    intraData2(4) = {cali_amp83};total_intraData2(idx,4) = {[reshape(amp83,1,[]),reshape(pha83,1,[])]};
    % Data set 3
    bgdata=textread(filename3); %Reading raw data %Source and Detector geometry
    if mode == 1
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_WashU(bgdata,source,detect,sddist_matrix);
    elseif mode == 2
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_UConn(bgdata,source,detect,sddist_matrix);
    elseif mode == 3
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_sys4_FPGA_ref_phase(bgdata,source,detect,sddist_matrix);
    else
        [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_sys6(bgdata,source,detect,0);
    end
    cali_amp74=log(sddist_matrix.^2.*amp74);
    cali_amp78=log(sddist_matrix.^2.*amp78);
    cali_amp80=log(sddist_matrix.^2.*amp80);
    cali_amp83=log(sddist_matrix.^2.*amp83);
    intraData3(1) = {cali_amp74};total_intraData3(idx,1) = {[reshape(amp74,1,[]),reshape(pha74,1,[])]};
    intraData3(2) = {cali_amp78};total_intraData3(idx,2) = {[reshape(amp78,1,[]),reshape(pha78,1,[])]};
    intraData3(3) = {cali_amp80};total_intraData3(idx,3) = {[reshape(amp80,1,[]),reshape(pha80,1,[])]};
    intraData3(4) = {cali_amp83};total_intraData3(idx,4) = {[reshape(amp83,1,[]),reshape(pha83,1,[])]};
end
waitbar(1,f,'Finished');
pause(0.5)
tar_alldata={total_tarData1;total_tarData2;total_tarData3};
ref_alldata={total_refData1;total_refData2;total_refData3};
intra_alldata={total_intraData1;total_intraData2;total_intraData3};
close(f)