function [pertub_Features,aveY] = mismatch_process(ref_isMotion, tar_isMotion, tar_nLesion, ref_nLesion, tar_alldata, ref_alldata, s_geom, source, detect, ref_numbers)
f = waitbar(0,'Please wait for mismatch checking results ...');
pause(0.5)      
waitbar(.05,f,'Please wait for mismatch checking results ...');
fprintf('Perturbation processing...\n')
ref_isMotion(:)=0;
numbers = 0;
no_motion_idx = [];
for tar_idx = 1:tar_nLesion
    for ref_idx = 1:ref_nLesion
        if tar_isMotion(2*tar_idx-1) ~= 1 && tar_isMotion(2*tar_idx) ~= 1
            no_motion_idx = [no_motion_idx, tar_idx];
            if ref_isMotion(2*ref_idx-1) ~= 1 && ref_isMotion(2*ref_idx) ~= 1
                numbers = numbers +1;
            end
        end
    end
end % count the number of ref-tar pair and document tar no motion index
no_motion_idx=unique(no_motion_idx);
[m,n] = size(no_motion_idx);
fprintf('Target side without motion:\n')
fprintf('%.4g ', no_motion_idx)
fprintf('\n')
index_chosen = 0;
while index_chosen == 0
    index_chosen = round(rand(1) * n);
end
total_tarData1 = tar_alldata{1};
total_tarData2 = tar_alldata{2};
total_tarData3 = tar_alldata{3};
total_refData1 = ref_alldata{1};
total_refData2 = ref_alldata{2};
total_refData3 = ref_alldata{3};
% index_chosen = n;
pertub_Features = zeros(numbers*4/n,253);
numbers = 0;
waitbar(.1,f,'Please wait for mismatch checking results ...');
% for tar_idx = 1:tar_nLesion
for tar_idx = no_motion_idx(index_chosen):no_motion_idx(index_chosen)
    for ref_idx = 1:ref_nLesion
        if tar_isMotion(2*tar_idx-1) ~= 1 && tar_isMotion(2*tar_idx) ~= 1
            if ref_isMotion(2*ref_idx-1) ~= 1 && ref_isMotion(2*ref_idx) ~= 1
                numbers = numbers + 1;
                avg_tar = zeros(4,length(total_tarData1{1,1}));
                avg_ref = zeros(4,length(total_tarData1{1,1}));
                pertubations = zeros(4,length(total_tarData1{1,1}));
                real_pertubations = zeros(4,length(total_tarData1{1,1})/2);
                distance = zeros(4,length(total_tarData1{1,1})/2);
                tar_whole_data = zeros(4,length(total_tarData1{1,1})/2);
                ref_whole_data = zeros(4,length(total_tarData1{1,1})/2);
                [m,n] = size(pertubations);
                singleset_features = zeros(m,14);
                label = zeros(4,1);
                for i = 1:4
                    avg_tar(i,:) = (total_tarData1{tar_idx,i} + total_tarData2{tar_idx,i} + total_tarData3{tar_idx,i})/3;
                    avg_ref(i,:) = (total_refData1{ref_idx,i} + total_refData2{ref_idx,i} + total_refData3{ref_idx,i})/3;
                    [m,n] = size(avg_tar);
                    tar_whole_data(i,:) = avg_tar(i,1:n/2).*exp(avg_tar(i,n/2+1:end)*1i);
                    ref_whole_data(i,:) = avg_ref(i,1:n/2).*exp(avg_ref(i,n/2+1:end)*1i);
                    real_pertubations(i,:) = (tar_whole_data(i,:)-ref_whole_data(i,:))./ref_whole_data(i,:);
                    pertubations(i,1:n/2) = real(real_pertubations(i,:));
                    pertubations(i,n/2+1:end) = imag(real_pertubations(i,:));
                    distance(i,:) = sqrt(pertubations(i,1:n/2).*pertubations(i,1:n/2)+pertubations(i,(n/2+1):end).*pertubations(i,(n/2+1):end));
                    if ~isempty(find(distance(i,:)>1))
                        label(i) = 1;
                    end
                    if mean(pertubations(i,1:n/2)) > 0.3
                        label(i) = 1;
                    end
                end      
                pertubations = [pertubations,label];
                figure(1);
                for i = 1:4
                    subplot(2,2,i)
                    plot(real_pertubations(i,:),'.')
                    title([num2str(no_motion_idx(index_chosen)-1) ' tar VS ' num2str(ref_idx+tar_nLesion-1) ' ref, wavelength ' num2str(i)])
                    hold on
                    rectangle('Position',[-1,-1,2,2],'Curvature',[1,1]),axis equal
                end
                close
%                 fourwave_features=[fourwave_features,label];
                pertub_Features(4*(numbers-1)+1:4*numbers,:) = pertubations;
            end
        end
    end
end
if s_geom(1,2) ~= 4.012
    pertub_Features_copy = pertub_Features(:,1:n);
    pertub_Features_copy_real = pertub_Features_copy(:,1:n/2);
    pertub_Features_copy_imag = pertub_Features_copy(:,n/2+1:end);
    pertub_Features_copy_real = reshape(pertub_Features_copy_real,[numbers*4,source,detect]);
    pertub_Features_copy_imag = reshape(pertub_Features_copy_imag,[numbers*4,source,detect]);
    for idx = 1:numbers*4
        real_store = squeeze(pertub_Features_copy_real(idx,:,:));
        real_exchange = real_store([9,5,1,6,2,7,3,8,4],[2,6,11,13,1,5,9,3,8,10,14,4,12,7]);
        real_reshape = reshape(real_exchange,1,[]);
        imag_store = squeeze(pertub_Features_copy_imag(idx,:,:));
        imag_exchange = imag_store([9,5,1,6,2,7,3,8,4],[2,6,11,13,1,5,9,3,8,10,14,4,12,7]);
        imag_reshape = reshape(imag_exchange,1,[]);
        pertub_Features(idx,:) = [real_reshape,imag_reshape,pertub_Features(idx,n+1)];
    end
end
waitbar(.66,f,'Please wait for mismatch checking results ...');
net = importONNXNetwork('122net_1.onnx','OutputLayerType','regression');
load('122pythonpara_1.mat')
norm_data = [(pertub_Features(:,1:n) - parameter(2,:))./(parameter(1,:) - parameter(2,:)),pertub_Features(:,n+1)];
YPredicted = predict(net,norm_data(:,1:n));
pertub_Features = [pertub_Features,YPredicted];
Y = reshape(YPredicted,4,[]);
aveY = mean(Y,1);
[min_Y, index] = mink(aveY,5);
len = length(min_Y);
waitbar(1,f,'Finished');
close(f)
if max(aveY) < 0.1
    if len == 2
        msgbox(["Mismatch checking finished, Ref suggestion:";sprintf('best = %2g second = %2g',ref_numbers(index(1:2)));"All reference are good to use"]);
    elseif len == 3
        msgbox(["Mismatch checking finished, Ref suggestion:";sprintf('best = %2g second = %2g third = %2g',ref_numbers(index(1:3)));"All reference are good to use"]);
    elseif len == 4
        msgbox(["Mismatch checking finished, Ref suggestion:";sprintf('best = %2g second = %2g third = %2g fourth = %2g',ref_numbers(index(1:4)));"All reference are good to use"]);
    elseif len >= 5
        msgbox(["Mismatch checking finished, Ref suggestion:";sprintf('best = %2g second = %2g third = %2g fourth = %2g fifth = %2g',ref_numbers(index(1:5)));"All reference are good to use"]);
    else
        errordlg('Only have 1 reference set.','Warning');
    end
elseif min(aveY) > 0.4
    if len == 2
        msgbox(["All references are not good to use,";sprintf('best = %2g second = %2g',ref_numbers(index(1:2)));'Shuying''s tar to perturbation is recommended']);
    elseif len == 3
        msgbox(["All references are not good to use,";sprintf('best = %2g second = %2g third = %2g',ref_numbers(index(1:3)));'Shuying''s tar to perturbation is recommended']);
    elseif len == 4
        msgbox(["All references are not good to use,";sprintf('best = %2g second = %2g third = %2g fourth = %2g',ref_numbers(index(1:4)));'Shuying''s tar to perturbation is recommended']);
    elseif len >= 5
        msgbox(["All references are not good to use,";sprintf('best = %2g second = %2g third = %2g fourth = %2g fifth = %2g',ref_numbers(index(1:5)));'Shuying''s tar to perturbation is recommended']);
    else
        errordlg('Only have 1 reference set.','Warning');
    end
else
    if len == 2
        msgbox(["Mismatch checking finished, Ref suggestion:";sprintf('best = %2g second = %2g',ref_numbers(index(1:2)))]);
    elseif len == 3
        msgbox(["Mismatch checking finished, Ref suggestion:";sprintf('best = %2g second = %2g third = %2g',ref_numbers(index(1:3)))]);
    elseif len == 4
        msgbox(["Mismatch checking finished, Ref suggestion:";sprintf('best = %2g second = %2g third = %2g fourth = %2g',ref_numbers(index(1:4)))]);
    elseif len >= 5
        msgbox(["Mismatch checking finished, Ref suggestion:";sprintf('best = %2g second = %2g third = %2g fourth = %2g fifth = %2g',ref_numbers(index(1:5)))]);
    else
        errordlg('Only have 1 reference set.','Warning');
    end
end

end