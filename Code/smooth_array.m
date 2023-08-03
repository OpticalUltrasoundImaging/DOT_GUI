function [phase,topoutlier,botoutlier] = smooth_array(phase,sddist)

len = length(phase);
if len < 3
	return;
end

diffVal = pi;
chngVal = 2*pi;
B = 1:1:length(phase);

maxPhase = max(phase);
minPhase = min(phase);

A = [sddist' phase' B'];    % create a length(phase) by 3
C = sortrows(A, [1 2]);         	% sorted by sddist
ph = C(:,2);

for k=1:len-1
    if abs(ph(k+1) - ph(k)) > diffVal
        if ph(k+1) > ph(k)
            if ph(k+1) - chngVal > minPhase - diffVal
                ph(k+1) = ph(k+1) - chngVal;
            end
        else 
            if ph(k+1) + chngVal < maxPhase + diffVal
                ph(k+1) = ph(k+1) + chngVal;
            end
        end
    end
end

C(:,2) = ph; 
D = sortrows(C, 3);
phase = D(:,2)';
diff = D(:,2)-A(:,2);
topoutlier = find(diff < -diffVal);
botoutlier = find(diff > diffVal);
% c = polyfit(sddist,phase,1);
% y_est = polyval(c,sddist);
% SD_idx = find(sddist > 4.5);
% phase_copy = phase;
% phase_copy(SD_idx) = 0;
% phase_copy = phase_copy(phase_copy~=0);
% sddist_copy = sddist(sddist <= 4.5);
% c1 = polyfit(sddist_copy,phase_copy,1);
% y_est1 = polyval(c1,sddist);
% figure(2);
% plot(sddist,phase,'bo');hold on;
% plot(sddist,y_est)
% plot(sddist,y_est1)
% diffs = phase - y_est;
% abs_diffs = abs(diffs);
% mean_diff = mean(abs_diffs);
% std_diff = std(abs_diffs);
% figure(1);plot(sddist,diffs,'bo')
% zero_line = zeros(1,126);
% hold on;plot(sddist,zero_line)