
% %transform wave to amplitude and phase

function [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_sys6(bgdata,source,detect,level)
channel=detect+1;
size(bgdata);

s_total = size(bgdata,1)/channel ; %number of one set data

for jj = 1:s_total
  
   wv = bgdata(jj*channel-detect:jj*channel-1,:)';  %seperate real data na d reference
   ref = bgdata(jj*channel,:)'; % reference
   %wv = conv2(ref(1:150),wv);
   %normf = max(ref);
   %wv = wv(151:length(ref)-150,:)/normf/75;
   %ref = conv(ref(1:150),ref);
   %ref = ref(151:length(ref)-150)/normf/75;
    wv_h = hilbert(wv);
    ref_h = hilbert(ref);
    amp(jj,:) = mean(abs(wv_h));
    %amp(jj,:) = max(abs(wv_h));
    phase(jj,:) = mean(unwrap(angle(wv_h)));
    phase(jj,:) = mean(unwrap(angle(ref_h)))-phase(jj,:);
    phase(jj,:) = mod(phase(jj,:), 2*pi);
   
end

bga_high=[];
bga_low=[];   
bgp_high=[];
bgp_low=[];  
size(amp)
if (level==1)
	for iii=1:4   %four wave length 740,780,830,808
		for i=1:source
		    bga_high=[bga_high;amp(i+(iii-1)*source*2,:)];  %first time is high voltage range
            bga_low=[bga_low;amp(i+(iii-1)*source*2+source,:)];   %second time is low voltage range
            bgp_high=[bgp_high;phase(i+(iii-1)*source*2,:)];
            bgp_low=[bgp_low;phase(i+(iii-1)*source*2+source,:)];
        end
    end
            
    [b_row,b_col]=size(bga_high);  %36*14    4 wavelength*9 source *14 detector
%     for kk=1:b_row
%           for ll=1:b_col
%               if(bga_high(kk,ll)<0.95)  %use 0.95 as criteria, not exactly. low than that use small range value
%                   bga_high(kk,ll)=bga_low(kk,ll);    %use 0.45 as criteria is better
%                   bgp_high(kk,ll)=bgp_low(kk,ll);
%               end;
%           end;
%     end;
     
    
elseif (level==0)
    bga_high=amp;
    bgp_high=phase;
end


amp74 = [bga_high(1:source,:)];     %seperate as different source
amp78 = [bga_high(source+1:2*source,:)];
amp80 = [bga_high(2*source+1:3*source,:)];
amp83 = [bga_high(3*source+1:4*source,:)];

pha74 = [bgp_high(1:source,:)];
pha78 = [bgp_high(source+1:2*source,:)];
pha80 = [bgp_high(2*source+1:3*source,:)];
pha83 = [bgp_high(3*source+1:4*source,:)];
