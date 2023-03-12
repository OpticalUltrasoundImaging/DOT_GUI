function [tar_isMotion, ref_isMotion] = motion_detect(tar_data_path, ref_data_path, tar_nLesion, ref_nLesion, meanTol, ptDiffTol, badptsTol, source, detect, sddist_matrix, tar_alldata, ref_alldata)
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

%% Load data and do motion detection
f = waitbar(0,'Please wait...');
pause(0.5)
waitbar(.1,f,'Tar checking...');
pause(0.5)
% Intial a motion detection binary vecotor.
Ns = source;
Nd = detect;
% Motion detection is feature based, totally 50 features. Generate a matrix
% to store these features. The 51 is motion (1) or no motion (0)
tar_Features = zeros(2*tar_nLesion, 51);
tar_isMotion = zeros(2*tar_nLesion,1);
% Based on the number of lesion data, we read 3 data sets in a row to
% perform motion detection
tar_repeat = 1;
tar_meanTol = meanTol;
tar_varTol = 0.25;
tar_ptDiffTol = ptDiffTol;
tar_badptsTol = badptsTol;
% store the calibrated data for perturbation
total_tarData1 = tar_alldata{1};
total_tarData2 = tar_alldata{2};
total_tarData3 = tar_alldata{3};
number_of_pair = Ns * Nd;
% if all data are not good, adjust threshold and repeat
while tar_repeat
fprintf('Target side motion detection...\n')
for idx = 1:tar_nLesion
    amp74 = reshape(total_tarData1{idx,1}(1:number_of_pair),Ns,Nd);
    amp78 = reshape(total_tarData1{idx,2}(1:number_of_pair),Ns,Nd);
    amp80 = reshape(total_tarData1{idx,3}(1:number_of_pair),Ns,Nd);
    amp83 = reshape(total_tarData1{idx,4}(1:number_of_pair),Ns,Nd);
    cali_amp74=log(sddist_matrix.^2.*amp74);
    cali_amp78=log(sddist_matrix.^2.*amp78);
    cali_amp80=log(sddist_matrix.^2.*amp80);
    cali_amp83=log(sddist_matrix.^2.*amp83);
    tarData1(1) = {cali_amp74};
    tarData1(2) = {cali_amp78};
    tarData1(3) = {cali_amp80};
    tarData1(4) = {cali_amp83};
    % Data set 2
    amp74 = reshape(total_tarData2{idx,1}(1:number_of_pair),Ns,Nd);
    amp78 = reshape(total_tarData2{idx,2}(1:number_of_pair),Ns,Nd);
    amp80 = reshape(total_tarData2{idx,3}(1:number_of_pair),Ns,Nd);
    amp83 = reshape(total_tarData2{idx,4}(1:number_of_pair),Ns,Nd);
    cali_amp74=log(sddist_matrix.^2.*amp74);
    cali_amp78=log(sddist_matrix.^2.*amp78);
    cali_amp80=log(sddist_matrix.^2.*amp80);
    cali_amp83=log(sddist_matrix.^2.*amp83);
    tarData2(1) = {cali_amp74};
    tarData2(2) = {cali_amp78};
    tarData2(3) = {cali_amp80};
    tarData2(4) = {cali_amp83};
    % Data set 3
    amp74 = reshape(total_tarData3{idx,1}(1:number_of_pair),Ns,Nd);
    amp78 = reshape(total_tarData3{idx,2}(1:number_of_pair),Ns,Nd);
    amp80 = reshape(total_tarData3{idx,3}(1:number_of_pair),Ns,Nd);
    amp83 = reshape(total_tarData3{idx,4}(1:number_of_pair),Ns,Nd);
    cali_amp74=log(sddist_matrix.^2.*amp74);
    cali_amp78=log(sddist_matrix.^2.*amp78);
    cali_amp80=log(sddist_matrix.^2.*amp80);
    cali_amp83=log(sddist_matrix.^2.*amp83);
    tarData3(1) = {cali_amp74};
    tarData3(2) = {cali_amp78};
    tarData3(3) = {cali_amp80};
    tarData3(4) = {cali_amp83};
    
    %% Compare the point-wise relative difference of those three data sets
    % 1 and 2, 2 and 3
    % Initial matrix
    amp_dist_12=cell(4,1);
    amp_dist_23=cell(4,1);
    % Compute difference for each wavelength, delete small distance in
    % case of PMT saturation
    rawSD_idx = find(sddist_matrix<2.8);
    for wavidx=1:4
        % Load amplitude and phase data from cells
        amp1 = tarData1{wavidx}/max(max(tarData1{wavidx}));
        amp2 = tarData2{wavidx}/max(max(tarData2{wavidx}));
        amp3 = tarData3{wavidx}/max(max(tarData3{wavidx}));
        
        % Compute point-wise distance
        dist_amp12=abs(amp1-amp2);
        dist_amp23=abs(amp2-amp3);
        
        % Put into cell structure to store
        amp_dist_12(wavidx)={dist_amp12};
        amp_dist_23(wavidx)={dist_amp23};
    end
    %% After computing the relative difference, first do a rough comparison
    % Mean difference or variance > mean tolerance, marked as bad data
    % First, compute mean value and variance, if one of them is larger 
    % than tolerance, marked as motion
    
    % To get rid of some extreme points, we first use outlier remover
    % function then calculate the mean and variance.
    % Also recording outlier index for later steps of motion detection
    tar_mean_12 = zeros(4,1);
    tar_mean_23 = zeros(4,1);
    tar_var_12 = zeros(4,1);
    tar_var_23 = zeros(4,1);
%     tar_std_12 = zeros(4,1);
%     tar_std_23 = zeros(4,1);
    for wavidx = 1:4
        % Etract each set of data
        ad12=amp_dist_12{wavidx};
        ad23=amp_dist_23{wavidx};
  
        tar_mean_12(wavidx) = mean2(ad12);
        tar_mean_23(wavidx) = mean2(ad23);

        tar_var_12(wavidx) = std2(ad12)*std2(ad12);
        tar_var_23(wavidx) = std2(ad23)*std2(ad12);
        
%         tar_std_12(wavidx) = std2(ad12);
%         tar_std_23(wavidx) = std2(ad23);
        
        tar_Features(idx*2-1, wavidx) = tar_mean_12(wavidx);
        tar_Features(idx*2, wavidx) = tar_mean_23(wavidx);
        tar_Features(idx*2-1, 46+wavidx) = tar_var_12(wavidx);
        tar_Features(idx*2, 46+wavidx) = tar_var_23(wavidx);
    end
    
    % After computing mean and var, compare with tolerance
    if max(tar_mean_12)>tar_meanTol
        tar_isMotion(idx*2-1) = 1; % Larger than tolerance, then marked as motion data sets
    end
    
    if max(tar_mean_23)>tar_meanTol
        tar_isMotion(idx*2) = 1;
    end
    
    if max(tar_var_12)>tar_varTol
        tar_isMotion(idx*2-1) = 1;
    end
    
    if max(tar_var_23)>tar_varTol
        tar_isMotion(idx*2) = 1;
    end
    
    %% If pass the mean and var test, then go to next step
    % To see is there any source pair have larger difference (Which
    % means motion exists)
    tar_DiffPt_12 = cell(4,1);
    tar_DiffPt_23 = cell(4,1);
    
    % Large source-detector separation should have more tolerance
    % Find large source-detector separation index
    
    % If SD distance>5.5cm, then consider as a large source-detector
    % separation
    SD_idx = find(sddist_matrix>5.5);
    ptTol_matrix = tar_ptDiffTol *ones(Ns,Nd);
    ptTol_matrix(SD_idx) = 1.5*tar_ptDiffTol;
    for wavidx = 1:4
        % Get difference matrix
        d1 = amp_dist_12{wavidx};
        d2 = amp_dist_23{wavidx};
        Idx1 = zeros(Ns,Nd);
        Idx2 = zeros(Ns,Nd);
        Idx1((d1-ptTol_matrix)>0)=1;
        Idx2((d2-ptTol_matrix)>0)=1;
        tar_DiffPt_12(wavidx) = {Idx1};
        tar_DiffPt_23(wavidx) = {Idx2};
    end
    
    % After get large different pt index, check the continuity for each
    % source.
    tar_rowSum_12 = zeros(9,4); % # of source * # of wavelenghth
    tar_rowSum_23 = zeros(9,4);
    for wavidx = 1:4
        % Get data for all wavelenght
        DiffIdx_12 = tar_DiffPt_12{wavidx};
        DiffIdx_23 = tar_DiffPt_23{wavidx};
        % Check source by source by sum of row
        tar_rowSum_12(:,wavidx) = sum(DiffIdx_12,2);
        tar_rowSum_23(:,wavidx) = sum(DiffIdx_23,2);
        
        tar_Features(idx*2-1, 4+(wavidx-1)*9+1:4+wavidx*9) = reshape(tar_rowSum_12(:,wavidx),1,9);
        tar_Features(idx*2, 4+(wavidx-1)*9+1:4+wavidx*9) = reshape(tar_rowSum_23(:,wavidx),1,9);
    end
    
    % After check the row sum. If exists any of them have larger than the
    % tolerance, the marked as motion data
    
    % check how many big difference in one source-all detectors data
    if sum(sum(tar_rowSum_12>tar_badptsTol))>0 
        tar_isMotion(idx*2-1) = 1;
    end
    if sum(sum(tar_rowSum_23>tar_badptsTol))>0
        tar_isMotion(idx*2) = 1;
    end
    % check how many big difference in whole data
    if sum(sum(tar_rowSum_12)>10)>0 
        tar_isMotion(idx*2-1) = 1;
    end
    if sum(sum(tar_rowSum_23)>10)>0
        tar_isMotion(idx*2) = 1;
    end
    
    if idx == tar_nLesion
        motion_sum = sum(tar_isMotion);
        if motion_sum > 0.8 *length(tar_isMotion)
            tar_ptDiffTol = 1.25 *tar_ptDiffTol;
            tar_meanTol = 1.25 * tar_meanTol;
            tar_varTol = 1.25 * tar_varTol;
            tar_isMotion = zeros(2*tar_nLesion,1);
            tar_repeat = 1;
        else
            tar_repeat = 0;
        end
    end
    tar_Features(idx*2-1, 41) = sum(sum(tar_rowSum_12>tar_badptsTol));
    tar_Features(idx*2, 41) = sum(sum(tar_rowSum_23>tar_badptsTol));
    tar_Features(idx*2-1, 42:45) = sum(tar_rowSum_12);
    tar_Features(idx*2, 42:45) = sum(tar_rowSum_23);
    tar_Features(idx*2-1, 46) = sum(sum(tar_rowSum_12));
    tar_Features(idx*2, 46) = sum(sum(tar_rowSum_23));
    tar_Features(idx*2-1, 51) = tar_isMotion(idx*2-1);
    tar_Features(idx*2, 51) = tar_isMotion(idx*2);
end
end
waitbar(.5,f,'Ref checking...');
pause(0.1)
%% reference side data
% Motion detection is feature based, totally 50 features. Generate a matrix
% to store these features. The 51 is motion (1) or no motion (0)
ref_Features = zeros(2*ref_nLesion, 51);
ref_isMotion = zeros(2*ref_nLesion, 1);
% Based on the number of lesion data, we read 3 data sets in a row to
% perform motion detection
ref_repeat = 1;
ref_meanTol = meanTol;
ref_varTol = 0.25;
ref_ptDiffTol = ptDiffTol;
ref_badptsTol = badptsTol;
% store the calibrated data for perturbation
total_refData1 = ref_alldata{1};
total_refData2 = ref_alldata{2};
total_refData3 = ref_alldata{3};
while ref_repeat
fprintf('Reference side motion detection...\n')
for idx = 1:ref_nLesion
    amp74 = reshape(total_refData1{idx,1}(1:number_of_pair),Ns,Nd);
    amp78 = reshape(total_refData1{idx,2}(1:number_of_pair),Ns,Nd);
    amp80 = reshape(total_refData1{idx,3}(1:number_of_pair),Ns,Nd);
    amp83 = reshape(total_refData1{idx,4}(1:number_of_pair),Ns,Nd);
    cali_amp74=log(sddist_matrix.^2.*amp74);
    cali_amp78=log(sddist_matrix.^2.*amp78);
    cali_amp80=log(sddist_matrix.^2.*amp80);
    cali_amp83=log(sddist_matrix.^2.*amp83);
    refData1(1) = {cali_amp74};
    refData1(2) = {cali_amp78};
    refData1(3) = {cali_amp80};
    refData1(4) = {cali_amp83};
    % Data set 2
    amp74 = reshape(total_refData2{idx,1}(1:number_of_pair),Ns,Nd);
    amp78 = reshape(total_refData2{idx,2}(1:number_of_pair),Ns,Nd);
    amp80 = reshape(total_refData2{idx,3}(1:number_of_pair),Ns,Nd);
    amp83 = reshape(total_refData2{idx,4}(1:number_of_pair),Ns,Nd);
    cali_amp74=log(sddist_matrix.^2.*amp74);
    cali_amp78=log(sddist_matrix.^2.*amp78);
    cali_amp80=log(sddist_matrix.^2.*amp80);
    cali_amp83=log(sddist_matrix.^2.*amp83);
    refData2(1) = {cali_amp74};
    refData2(2) = {cali_amp78};
    refData2(3) = {cali_amp80};
    refData2(4) = {cali_amp83};
    % Data set 3
    amp74 = reshape(total_refData3{idx,1}(1:number_of_pair),Ns,Nd);
    amp78 = reshape(total_refData3{idx,2}(1:number_of_pair),Ns,Nd);
    amp80 = reshape(total_refData3{idx,3}(1:number_of_pair),Ns,Nd);
    amp83 = reshape(total_refData3{idx,4}(1:number_of_pair),Ns,Nd);
    cali_amp74=log(sddist_matrix.^2.*amp74);
    cali_amp78=log(sddist_matrix.^2.*amp78);
    cali_amp80=log(sddist_matrix.^2.*amp80);
    cali_amp83=log(sddist_matrix.^2.*amp83);
    refData3(1) = {cali_amp74};
    refData3(2) = {cali_amp78};
    refData3(3) = {cali_amp80};
    refData3(4) = {cali_amp83};
    
    %% Compare the point-wise relative difference of those three data sets
    % 1 and 2, 2 and 3
    % Initial matrix
    amp_dist_12=cell(4,1);
    amp_dist_23=cell(4,1);
    % Compute difference for each wavelength, delete small distance in
    % case of PMT saturation
    rawSD_idx = find(sddist_matrix<2.8);
    for wavidx=1:4
        % Load amplitude and phase data from cells
        amp1 = refData1{wavidx}/max(max(refData1{wavidx}));
        amp2 = refData2{wavidx}/max(max(refData2{wavidx}));
        amp3 = refData3{wavidx}/max(max(refData3{wavidx}));
        
        % Compute point-wise distance
        dist_amp12=abs(amp1-amp2);
        dist_amp23=abs(amp2-amp3);
        
        % Put into cell structure to store
        amp_dist_12(wavidx)={dist_amp12};
        amp_dist_23(wavidx)={dist_amp23};
    end
    %% After computing the relative difference, first do a rough comparison
    % Mean difference or variance > mean tolerance, marked as bad data
    % First, compute mean value and variance, if one of them is larger 
    % than tolerance, marked as motion
    
    % To get rid of some extreme points, we first use outlier remover
    % function then calculate the mean and variance.
    % Also recording outlier index for later steps of motion detection
    ref_mean_12 = zeros(4,1);
    ref_mean_23 = zeros(4,1);
    ref_var_12 = zeros(4,1);
    ref_var_23 = zeros(4,1);
%     ref_std_12 = zeros(4,1);
%     ref_std_23 = zeros(4,1);
    for wavidx = 1:4
        % Etract each set of data
        ad12=amp_dist_12{wavidx};
        ad23=amp_dist_23{wavidx};
  
        ref_mean_12(wavidx) = mean2(ad12);
        ref_mean_23(wavidx) = mean2(ad23);

        ref_var_12(wavidx) = std2(ad12)*std2(ad12);
        ref_var_23(wavidx) = std2(ad23)*std2(ad12);
        
%         ref_std_12(wavidx) = std2(ad12);
%         ref_std_23(wavidx) = std2(ad23);
        
        ref_Features(idx*2-1, wavidx) = tar_mean_12(wavidx);
        ref_Features(idx*2, wavidx) = tar_mean_23(wavidx);
        ref_Features(idx*2-1, 46+wavidx) = tar_var_12(wavidx);
        ref_Features(idx*2, 46+wavidx) = tar_var_23(wavidx);
    end
    
    % After computing mean and var, compare with tolerance
    if max(ref_mean_12)>ref_meanTol
        ref_isMotion(idx*2-1) = 1; % Larger than tolerance, then marked as motion data sets
    end
    
    if max(ref_mean_23)>ref_meanTol
        ref_isMotion(idx*2) = 1; 
    end
    
    if max(ref_var_12)>ref_varTol
        ref_isMotion(idx*2-1) = 1; 
    end
    
    if max(ref_var_23)>ref_varTol
        ref_isMotion(idx*2) = 1; 
    end
    
    %% If pass the mean and var test, then go to next step
    % To see is there any source pair have larger difference (Which
    % means motion exists)
    ref_DiffPt_12 = cell(4,1);
    ref_DiffPt_23 = cell(4,1);
    
    % Large source-detector separation have more tolerance
    % Find large source-detector separation index
    
    % If SD distance>5.5cm, then consider as a large source-detector
    % separation
    SD_idx = find(sddist_matrix>5.5);
    ptTol_matrix = ref_ptDiffTol *ones(Ns,Nd);
    ptTol_matrix(SD_idx) = 1.5*ref_ptDiffTol;
    for wavidx = 1:4
        % Get difference matrix
        d1 = amp_dist_12{wavidx};
        d2 = amp_dist_23{wavidx};
        Idx1 = zeros(Ns,Nd);
        Idx2 = zeros(Ns,Nd);
        Idx1((d1-ptTol_matrix)>0)=1;
        Idx2((d2-ptTol_matrix)>0)=1;
        ref_DiffPt_12(wavidx) = {Idx1};
        ref_DiffPt_23(wavidx) = {Idx2};
    end
    
    % After get large different pt index, check the continuity for each
    % source.
    ref_rowSum_12 = zeros(9,4); % # of source * # of wavelenghth
    ref_rowSum_23 = zeros(9,4);
    for wavidx = 1:4
        % Get data for all wavelenght
        DiffIdx_12 = ref_DiffPt_12{wavidx};
        DiffIdx_23 = ref_DiffPt_23{wavidx};
        % Check source by source by sum of row
        ref_rowSum_12(:,wavidx) = sum(DiffIdx_12,2);
        ref_rowSum_23(:,wavidx) = sum(DiffIdx_23,2);
        
        ref_Features(idx*2-1, 4+(wavidx-1)*9+1:4+wavidx*9) = reshape(ref_rowSum_12(:,wavidx),1,9);
        ref_Features(idx*2, 4+(wavidx-1)*9+1:4+wavidx*9) = reshape(ref_rowSum_23(:,wavidx),1,9);
    end
    % After check the row sum. If exists any of them have large the
    % tolerance, the marked as motion data
    if sum(sum(ref_rowSum_12>ref_badptsTol))>0
        ref_isMotion(idx*2-1) = 1;
    end
    if sum(sum(ref_rowSum_23>ref_badptsTol))>0
        ref_isMotion(idx*2) = 1;
    end
    
    if sum(sum(ref_rowSum_12)>10)>0
        ref_isMotion(idx*2-1) = 1;
    end
    if sum(sum(ref_rowSum_23)>10)>0
        ref_isMotion(idx*2) = 1;
    end
    
    if idx == ref_nLesion
        motion_sum = sum(ref_isMotion);
        if motion_sum > 0.8 *length(ref_isMotion)
            ref_ptDiffTol = 1.25 *ref_ptDiffTol;
            ref_meanTol = 1.25 * ref_meanTol;
            ref_varTol = 1.25 * ref_varTol;
            ref_isMotion = zeros(2*ref_nLesion,1);
            ref_repeat = 1;
        else
            ref_repeat = 0;
        end
    end
    ref_Features(idx*2-1, 41) = sum(sum(ref_rowSum_12>ref_badptsTol));
    ref_Features(idx*2, 41) = sum(sum(ref_rowSum_23>ref_badptsTol));
    ref_Features(idx*2-1, 42:45) = sum(ref_rowSum_12);
    ref_Features(idx*2, 42:45) = sum(ref_rowSum_23);
    ref_Features(idx*2-1, 46) = sum(sum(ref_rowSum_12));
    ref_Features(idx*2, 46) = sum(sum(ref_rowSum_23));
    ref_Features(idx*2-1, 51) = ref_isMotion(idx*2-1);
    ref_Features(idx*2, 51) = ref_isMotion(idx*2);
end
end
waitbar(1,f,'Outputing...');
pause(0.1)
close(f)
%% plot the target side amplitude data, sd-distance vs. amp
tar_file_names = {};
for i = 1:length(tar_isMotion)/2
    split_file_name = split(tar_data_path{3*i-2},'\');
    tar_file_names{i} = split_file_name{end};
    if tar_isMotion(2*i -1)==0 && tar_isMotion(2*i) ==0
        fprintf('3 subsets in tar data set %s are ok\n',split_file_name{end}(1:end-6))
    elseif tar_isMotion(2*i -1)==1 && tar_isMotion(2*i) ==1
        fprintf('3 subsets in tar data set %s all have motion\n', split_file_name{end}(1:end-6))
    elseif tar_isMotion(2*i -1)==1 && tar_isMotion(2*i) ==0
        fprintf('1st and 2nd in tar data set %s have motion\n', split_file_name{end}(1:end-6))
    else 
        fprintf('2nd and 3rd in tar data set %s have motion\n', split_file_name{end}(1:end-6))
    end
end
% it needs some time to plot, comment this part can save time
% plot set1 vs set2, set2 vs set3 for 4 wavelength, first figure is set1 vs
% set 2 in 740nm, second figure is set2 vs set3 in 740nm, third is set1 vs
% set2 in 785nm and so on.
% Totally have 8 figures (if data not too many), each figure contains 
% x pictures (x = number of data/ 3)
for idx = 1:tar_nLesion
    %%  Load txt file and put into data structure
    % Data set 1
    cali174 = log(sddist_matrix.^2.*reshape(total_tarData1{idx,1}(1:126),9,[]));
    cali178 = log(sddist_matrix.^2.*reshape(total_tarData1{idx,2}(1:126),9,[]));
    cali180 = log(sddist_matrix.^2.*reshape(total_tarData1{idx,3}(1:126),9,[]));
    cali183 = log(sddist_matrix.^2.*reshape(total_tarData1{idx,4}(1:126),9,[]));
    % Data set 2
    cali274 = log(sddist_matrix.^2.*reshape(total_tarData2{idx,1}(1:126),9,[]));
    cali278 = log(sddist_matrix.^2.*reshape(total_tarData2{idx,2}(1:126),9,[]));
    cali280 = log(sddist_matrix.^2.*reshape(total_tarData2{idx,3}(1:126),9,[]));
    cali283 = log(sddist_matrix.^2.*reshape(total_tarData2{idx,4}(1:126),9,[]));
    % Data set 3
    cali374 = log(sddist_matrix.^2.*reshape(total_tarData3{idx,1}(1:126),9,[]));
    cali378 = log(sddist_matrix.^2.*reshape(total_tarData3{idx,2}(1:126),9,[]));
    cali380 = log(sddist_matrix.^2.*reshape(total_tarData3{idx,3}(1:126),9,[]));
    cali383 = log(sddist_matrix.^2.*reshape(total_tarData3{idx,4}(1:126),9,[]));

    sddist_matrix1 = sddist_matrix;
    if ~isempty(rawSD_idx)
        sddist_matrix1(rawSD_idx) = [];
    end
    
    if idx > 12
        figure(3);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx-12)
        plot(sddist_matrix1,cali174,'r.');
        hold on
        plot(sddist_matrix1,cali274,'bo');
        legend('cali 1','cali 2');
        title([tar_file_names{idx}(1:end-6),'Amp 1 vs 2, 740nm'])
        
        figure(4);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx-12)
        plot(sddist_matrix1,cali274,'r.');
        hold on
        plot(sddist_matrix1,cali374,'bo');
        legend('cali 2','cali 3');
        title([tar_file_names{idx}(1:end-6),'Amp 2 vs 3, 740nm'])
        
        figure(7);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx-12)
        plot(sddist_matrix1,cali178,'r.');
        hold on
        plot(sddist_matrix1,cali278,'bo');
        legend('cali 1','cali 2');
        title([tar_file_names{idx}(1:end-6),'Amp 1 vs 2, 780nm'])

        figure(8);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx-12)
        plot(sddist_matrix1,cali278,'r.');
        hold on
        plot(sddist_matrix1,cali378,'bo');
        legend('cali 2','cali 3');
        title([tar_file_names{idx}(1:end-6),'Amp 2 vs 3, 780nm'])
        
        figure(11);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx-12)
        plot(sddist_matrix1,cali180,'r.');
        hold on
        plot(sddist_matrix1,cali280,'bo');
        legend('cali 1','cali 2');
        title([tar_file_names{idx}(1:end-6),'Amp 1 vs 2, 808nm'])

        figure(12);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx-12)
        plot(sddist_matrix1,cali280,'r.');
        hold on
        plot(sddist_matrix1,cali380,'bo');
        legend('cali 2','cali 3');
        title([tar_file_names{idx}(1:end-6),'Amp 2 vs 3, 808nm'])
        
        figure(15);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx-12)
        plot(sddist_matrix1,cali183,'r.');
        hold on
        plot(sddist_matrix1,cali283,'bo');
        legend('cali 1','cali 2');
        title([tar_file_names{idx}(1:end-6),'Amp 1 vs 2, 830nm'])

        figure(16);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx-12)
        plot(sddist_matrix1,cali283,'r.');
        hold on
        plot(sddist_matrix1,cali383,'bo');
        legend('cali 2','cali 3');
        title([tar_file_names{idx}(1:end-6),'Amp 2 vs 3, 830nm'])
    else
        figure(1);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx)
        plot(sddist_matrix1,cali174,'r.');
        hold on
        plot(sddist_matrix1,cali274,'bo');
        legend('cali 1','cali 2');
        title([tar_file_names{idx}(1:end-6),'Amp 1 vs 2, 740nm'])

        figure(2);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx)
        plot(sddist_matrix1,cali274,'r.');
        hold on
        plot(sddist_matrix1,cali374,'bo');
        legend('cali 2','cali 3');
        title([tar_file_names{idx}(1:end-6),'Amp 2 vs 3, 740nm'])
        
        figure(5);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx)
        plot(sddist_matrix1,cali178,'r.');
        hold on
        plot(sddist_matrix1,cali278,'bo');
        legend('cali 1','cali 2');
        title([tar_file_names{idx}(1:end-6),'Amp 1 vs 2, 780nm'])

        figure(6);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx)
        plot(sddist_matrix1,cali278,'r.');
        hold on
        plot(sddist_matrix1,cali378,'bo');
        legend('cali 2','cali 3');
        title([tar_file_names{idx}(1:end-6),'Amp 2 vs 3, 780nm'])
        
        figure(9);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx)
        plot(sddist_matrix1,cali180,'r.');
        hold on
        plot(sddist_matrix1,cali280,'bo');
        legend('cali 1','cali 2');
        title([tar_file_names{idx}(1:end-6),'Amp 1 vs 2, 808nm'])

        figure(10);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx)
        plot(sddist_matrix1,cali280,'r.');
        hold on
        plot(sddist_matrix1,cali380,'bo');
        legend('cali 2','cali 3');
        title([tar_file_names{idx}(1:end-6),'Amp 2 vs 3, 808nm'])
        
        figure(13);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx)
        plot(sddist_matrix1,cali183,'r.');
        hold on
        plot(sddist_matrix1,cali283,'bo');
        legend('cali 1','cali 2');
        title([tar_file_names{idx}(1:end-6),'Amp 1 vs 2, 830nm'])

        figure(14);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx)
        plot(sddist_matrix1,cali283,'r.');
        hold on
        plot(sddist_matrix1,cali383,'bo');
        legend('cali 2','cali 3');
        title([tar_file_names{idx}(1:end-6),'Amp 2 vs 3, 830nm'])
    end
end


%% plot the ref side amplitude data, sd-distance vs. amp
ref_file_names = {};
for i = 1:length(ref_isMotion)/2
    split_file_name = split(ref_data_path{3*i-2},'\');
    ref_file_names{i} = split_file_name{end};
    if ref_isMotion(2*i -1)==0 && ref_isMotion(2*i) ==0
        fprintf('3 subsets in ref data set %s are ok\n',split_file_name{end}(1:end-6))
    elseif ref_isMotion(2*i -1)==1 && ref_isMotion(2*i) ==1
        fprintf('3 subsets in ref data set %s all have motion\n', split_file_name{end}(1:end-6))
    elseif ref_isMotion(2*i -1)==1 && ref_isMotion(2*i) ==0
        fprintf('1st and 2nd in ref data set %s have motion\n', split_file_name{end}(1:end-6))
    else 
        fprintf('2nd and 3rd in ref data set %s have motion\n', split_file_name{end}(1:end-6))
    end
end
% it needs some time to plot, comment this part can save time
% plot set1 vs set2, set2 vs set3 for 4 wavelength
% Totally have 8 figures (if data not too many), each figure contains 
% x pictures (x = number of data/ 3)
for idx = 1:ref_nLesion
    %%  Load txt file and put into data structure
    % Data set 1
    cali174 = log(sddist_matrix.^2.*reshape(total_refData1{idx,1}(1:126),9,[]));
    cali178 = log(sddist_matrix.^2.*reshape(total_refData1{idx,2}(1:126),9,[]));
    cali180 = log(sddist_matrix.^2.*reshape(total_refData1{idx,3}(1:126),9,[]));
    cali183 = log(sddist_matrix.^2.*reshape(total_refData1{idx,4}(1:126),9,[]));
    % Data set 2
    cali274 = log(sddist_matrix.^2.*reshape(total_refData2{idx,1}(1:126),9,[]));
    cali278 = log(sddist_matrix.^2.*reshape(total_refData2{idx,2}(1:126),9,[]));
    cali280 = log(sddist_matrix.^2.*reshape(total_refData2{idx,3}(1:126),9,[]));
    cali283 = log(sddist_matrix.^2.*reshape(total_refData2{idx,4}(1:126),9,[]));
    % Data set 3
    cali374 = log(sddist_matrix.^2.*reshape(total_refData3{idx,1}(1:126),9,[]));
    cali378 = log(sddist_matrix.^2.*reshape(total_refData3{idx,2}(1:126),9,[]));
    cali380 = log(sddist_matrix.^2.*reshape(total_refData3{idx,3}(1:126),9,[]));
    cali383 = log(sddist_matrix.^2.*reshape(total_refData3{idx,4}(1:126),9,[]));

    sddist_matrix1 = sddist_matrix;
    if ~isempty(rawSD_idx)
        sddist_matrix1(rawSD_idx) = [];
    end
    
    if idx > 12
        figure(19);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx-12)
        plot(sddist_matrix1,cali174,'r.');
        hold on
        plot(sddist_matrix1,cali274,'bo');
        legend('cali 1','cali 2');
        title([tar_file_names{idx}(1:end-6),'Amp 1 vs 2, 740nm'])
        
        figure(20);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx-12)
        plot(sddist_matrix1,cali274,'r.');
        hold on
        plot(sddist_matrix1,cali374,'bo');
        legend('cali 2','cali 3');
        title([tar_file_names{idx}(1:end-6),'Amp 2 vs 3, 740nm'])
        
        figure(23);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx-12)
        plot(sddist_matrix1,cali178,'r.');
        hold on
        plot(sddist_matrix1,cali278,'bo');
        legend('cali 1','cali 2');
        title([tar_file_names{idx}(1:end-6),'Amp 1 vs 2, 780nm'])

        figure(24);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx-12)
        plot(sddist_matrix1,cali278,'r.');
        hold on
        plot(sddist_matrix1,cali378,'bo');
        legend('cali 2','cali 3');
        title([tar_file_names{idx}(1:end-6),'Amp 2 vs 3, 780nm'])
        
        figure(27);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx-12)
        plot(sddist_matrix1,cali180,'r.');
        hold on
        plot(sddist_matrix1,cali280,'bo');
        legend('cali 1','cali 2');
        title([tar_file_names{idx}(1:end-6),'Amp 1 vs 2, 808nm'])

        figure(28);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx-12)
        plot(sddist_matrix1,cali280,'r.');
        hold on
        plot(sddist_matrix1,cali380,'bo');
        legend('cali 2','cali 3');
        title([tar_file_names{idx}(1:end-6),'Amp 2 vs 3, 808nm'])
        
        figure(31);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx-12)
        plot(sddist_matrix1,cali183,'r.');
        hold on
        plot(sddist_matrix1,cali283,'bo');
        legend('cali 1','cali 2');
        title([tar_file_names{idx}(1:end-6),'Amp 1 vs 2, 830nm'])

        figure(32);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx-12)
        plot(sddist_matrix1,cali283,'r.');
        hold on
        plot(sddist_matrix1,cali383,'bo');
        legend('cali 2','cali 3');
        title([tar_file_names{idx}(1:end-6),'Amp 2 vs 3, 830nm'])
    else
        figure(17);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx)
        plot(sddist_matrix1,cali174,'r.');
        hold on
        plot(sddist_matrix1,cali274,'bo');
        legend('cali 1','cali 2');
        title([tar_file_names{idx}(1:end-6),'Amp 1 vs 2, 740nm'])

        figure(18);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx)
        plot(sddist_matrix1,cali274,'r.');
        hold on
        plot(sddist_matrix1,cali374,'bo');
        legend('cali 2','cali 3');
        title([tar_file_names{idx}(1:end-6),'Amp 2 vs 3, 740nm'])
        
        figure(21);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx)
        plot(sddist_matrix1,cali178,'r.');
        hold on
        plot(sddist_matrix1,cali278,'bo');
        legend('cali 1','cali 2');
        title([tar_file_names{idx}(1:end-6),'Amp 1 vs 2, 780nm'])

        figure(22);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx)
        plot(sddist_matrix1,cali278,'r.');
        hold on
        plot(sddist_matrix1,cali378,'bo');
        legend('cali 2','cali 3');
        title([tar_file_names{idx}(1:end-6),'Amp 2 vs 3, 780nm'])
        
        figure(25);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx)
        plot(sddist_matrix1,cali180,'r.');
        hold on
        plot(sddist_matrix1,cali280,'bo');
        legend('cali 1','cali 2');
        title([tar_file_names{idx}(1:end-6),'Amp 1 vs 2, 808nm'])

        figure(26);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx)
        plot(sddist_matrix1,cali280,'r.');
        hold on
        plot(sddist_matrix1,cali380,'bo');
        legend('cali 2','cali 3');
        title([tar_file_names{idx}(1:end-6),'Amp 2 vs 3, 808nm'])
        
        figure(29);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx)
        plot(sddist_matrix1,cali183,'r.');
        hold on
        plot(sddist_matrix1,cali283,'bo');
        legend('cali 1','cali 2');
        title([tar_file_names{idx}(1:end-6),'Amp 1 vs 2, 830nm'])

        figure(30);set(gcf,'outerposition',get(0,'screensize'));
        subplot(4,3,idx)
        plot(sddist_matrix1,cali283,'r.');
        hold on
        plot(sddist_matrix1,cali383,'bo');
        legend('cali 2','cali 3');
        title([tar_file_names{idx}(1:end-6),'Amp 2 vs 3, 830nm'])
     end
end
f = msgbox("Motion checking finished");