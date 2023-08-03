% Yasaman Ardeshirpour  - problems in calibration process are fixed - july
% 2008
% Yasaman Ardeshirpour - select and remove programs added for the
% perturbation - aug 2008
% Yasaman Ardeshirpour - Many Passing data information added and old one changed
% Yasaman Ardeshirpour - save data fixed
% Yasaman Ardeshirpour - Program changed to update the data everytime the remove buttons pressed
% Yasaman Ardeshirpour - passing data information improved - aug 2008
% Yasaman Ardeshirpour - program is modified for 9 sources and 14 detectors




pi=3.14159265358979; %pi
vel_c = 2.99792458e+10; %speed of light in vacum in cm
freq = 140; %modulation frequency MHz
semi_inf = 1; %semi_infinite weights
n_ref = 1.3333; %refractive index in medium
vel = vel_c/n_ref; %speed of light in medium in cm
omega = 2.0*pi*freq*1000000; %2pi freq
pnts=256;
turnpoint=0.0;   %one saturation point, maybe different for three wavelength
turnpoint74=turnpoint;
turnpoint78=turnpoint;
turnpoint80=turnpoint;
turnpoint83=turnpoint;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if freq==140
%      slope74=0.6;
%      trans74=0;
%      slope78=0.6;
%      trans78=-4.7;
%      slope80=0.6;
%      trans80=0.60;
%      slope83=0.0;
%      trans83=2;
% end

if freq==140
     slope74=0.0;
     trans74=0;
     slope78=0.0;
     trans78=0;
     slope80=0.0;
     trans80=0.00;
     slope83=0.0;
     trans83=0;
end
% elseif freq==50
%  
%     slope6=0.7;
%     trans6=0.5;
%     slope7=0.48;
%     trans7=0;
%     %slope8=0.6;
%     %trans8=1;
%     slope83=0.5;
%     trans83=1;
% elseif freq==250
%     slope6=0.72;
%     trans6=4;
%     slope7=0.6;
%     trans7=0;
%     %slope8=0.6;
%     %trans8=1;
%     slope83=0.5;
%     trans83=2.2;
% end
%     


si=source;
di=detect;
bgamp74=zeros(si,di);
bgamp78=zeros(si,di);
bgamp80=zeros(si,di);
bgamp83=zeros(si,di);
bgphase74=zeros(si,di);
bgphase78=zeros(si,di);
bgphase80=zeros(si,di);
bgphase83=zeros(si,di);

mi74=0;
mi78=0;
mi80=0;
mi83=0;
MA74=[];
MP74=[];
MA78=[];
MP78=[];
MA80=[];
MP80=[];
MA83=[];
MP83=[];
A_m74=[];
A_m78=[];
A_m80=[];
A_m83=[];
P_m74=[];
P_m78=[];
P_m80=[];
P_m83=[];

sddist_matrix74=sddist_matrix;
sddist_matrix78=sddist_matrix;
sddist_matrix80=sddist_matrix;
sddist_matrix83=sddist_matrix;
% pairs74=pairs;
% pairs78=pairs;
% pairs80=pairs;
% pairs83=pairs;
% Measmnt74 = Measmnt;
% Measmnt78 = Measmnt;
% Measmnt80 = Measmnt;
% Measmnt83 = Measmnt;
[Nmeas74,~] = size(Measmnt74);
[Nmeas78,~] = size(Measmnt78);
[Nmeas80,~] = size(Measmnt80);
[Nmeas83,~] = size(Measmnt83);
% sddist74 = sddist;
% sddist78 = sddist;
% sddist80 = sddist;
% sddist83 = sddist;
for si=1:source
   for di=1:detect
      rho74=sddist_matrix(si,di);
   		
		bgamp74(si,di)=bga74(si,di);
   		bgphase74(si,di)=bgp74(si,di);%-ps06(si);
   		if pairs74(si,di)
         	mi74=mi74+1;
         	A_m74(mi74)=bgamp74(si,di)*rho74^2;   %Amp*r^2
         	A_m74(mi74)=log(A_m74(mi74));
            P_m74(mi74)=bgphase74(si,di);
            %P_m74(mi74)=mod(P_m74(mi74)+slope74*rho74+trans74,2*pi)-slope74*rho74-trans74;%-slope6*rho6-trans6,2*pi)+slope6*rho6+trans6;  %????????????
            P_m74(mi74)=mod(P_m74(mi74)+1.5,2*pi)-1.5;
            
            %P_m6(mi6)=mod(P_m6(mi6)-6,2*pi)+6;
			   
     	end  %Form second step amplitude and phase. amplitude already * r^2(semi-infinte BC). phase is phase 
		
		if pairs74(si,di)    
         MA74=[MA74; zeros(1,source+detect)];    %The structure is a little different with old one
         MP74=[MP74; zeros(1,source+detect)];    %MA6 MP6 give the structure of source detector distribution and
         if si>1                                   % distance.|source          00000 detector             distance|
            MA74(mi74,si-1)=1;                       %          |source          00000     detector        distance|
            MP74(mi74,si-1)=1;                       %          |source          00000         detector    distance|
         end                                       %          |source          00000             detectordistance|
         MA74(mi74,source+di-1)=1;      %          |   source       00000 detector          distance|
         MP74(mi74,source+di-1)=1;      %          |   source       00000   detector       distance|
         MA74(mi74,source+detect)=rho74;            %          |   source       00000     detector    distance|
         MP74(mi74,source+detect)=rho74;            %          |   source       000000       detector distance|
        end
      
        
      rho78=sddist_matrix(si,di);		
   		
		bgamp78(si,di)=bga78(si,di);
   		bgphase78(si,di)=bgp78(si,di);%-ps07(si);
   		if pairs78(si,di)
         	mi78=mi78+1;
         	A_m78(mi78)=bgamp78(si,di)*rho78^2;   %Amp*r^2
         	A_m78(mi78)=log(A_m78(mi78));
            P_m78(mi78)=bgphase78(si,di);
            %P_m78(mi78)=mod(P_m78(mi78)-slope78*rho78-trans78,2*pi)+slope78*rho78+trans78;%-slope7*rho7-trans7,2*pi)+slope7*rho7+trans7;  %????????????
%			P_m78(mi78)=mod(P_m78(mi78)+2,2*pi)-2;
			P_m78(mi78)=mod(P_m78(mi78),2*pi);  % yasaman           
     		end
		
	   if pairs78(si,di)    
         MA78=[MA78; zeros(1,source+detect)];    %The structure is a little different with old one
         MP78=[MP78; zeros(1,source+detect)]; 
         if si>1
            MA78(mi78,si-1)=1;
            MP78(mi78,si-1)=1;
         end
         MA78(mi78,source+di-1)=1;
         MP78(mi78,source+di-1)=1;
         MA78(mi78,source+detect)=rho78;
         MP78(mi78,source+detect)=rho78;
      end
      
      rho80=sddist_matrix(si,di);
		
		bgamp80(si,di)=bga80(si,di);
   		bgphase80(si,di)=bgp80(si,di);%-ps083(si);
   		if pairs80(si,di)
         	mi80=mi80+1;
         	A_m80(mi80)=bgamp80(si,di)*rho80^2;   %Amp*r^2
         	A_m80(mi80)=log(A_m80(mi80));
            P_m80(mi80)=bgphase80(si,di);
            %P_m80(mi80)=mod(P_m80(mi80)+slope80*rho80+trans80,2*pi)-slope80*rho80-trans80;%    -slope80*rho80-trans80,2*pi)+slope80*rho80+trans80;  %????????????
%			P_m80(mi80)=mod(P_m80(mi80)+2,2*pi)-2;
			P_m80(mi80)=mod(P_m80(mi80),2*pi);            %yasaman
     		end
		 
		 if pairs80(si,di)    
         MA80=[MA80; zeros(1,source+2*detect)];    %The structure is a little different with old one
         MP80=[MP80; zeros(1,source+2*detect)]; 
         if si>1
            MA80(mi80,si-1)=1;
            MP80(mi80,si-1)=1;
         end
         MA80(mi80,source+di-1)=1;
         MP80(mi80,source+di-1)=1;
         MA80(mi80,source+detect)=rho80;
         MP80(mi80,source+detect)=rho80;
       end
      
      rho83=sddist_matrix(si,di);
		
		bgamp83(si,di)=bga83(si,di);
   		bgphase83(si,di)=bgp83(si,di);%-ps083(si);
   		if pairs83(si,di)
         	mi83=mi83+1;
         	A_m83(mi83)=bgamp83(si,di)*rho83^2;   %Amp*r^2
         	A_m83(mi83)=log(A_m83(mi83));
            P_m83(mi83)=bgphase83(si,di);
            %P_m83(mi83)=mod(P_m83(mi83)+slope83*rho83+trans83,2*pi)-slope83*rho83-trans83;%    -slope83*rho83-trans83,2*pi)+slope83*rho83+trans83;  %????????????
%			P_m83(mi83)=mod(P_m83(mi83)+2,2*pi)-2;
			P_m83(mi83)=mod(P_m83(mi83),2*pi);            
     		end
		 
		 if pairs83(si,di)    
         MA83=[MA83; zeros(1,source+detect)];    %The structure is a little different with old one
         MP83=[MP83; zeros(1,source+detect)]; 
         if si>1
            MA83(mi83,si-1)=1;
            MP83(mi83,si-1)=1;
         end
         MA83(mi83,source+di-1)=1;
         MP83(mi83,source+di-1)=1;
         MA83(mi83,source+detect)=rho83;
         MP83(mi83,source+detect)=rho83;
       end
    end
 end
 
if exist('A_m74_modified','var') && length(A_m74_modified)>1 && length(A_m74_modified{end}) == source*detect
    A_m74 = A_m74_modified{end};
    P_m74 = P_m74_modified{end};
end
if exist('A_m78_modified','var') && length(A_m78_modified)>1 && length(A_m78_modified{end}) == source*detect
    A_m78 = A_m78_modified{end};
    P_m78 = P_m78_modified{end};
end
if exist('A_m80_modified','var') && length(A_m80_modified)>1 && length(A_m80_modified{end}) == source*detect
    A_m80 = A_m80_modified{end};
    P_m80 = P_m80_modified{end};
end
if exist('A_m83_modified','var') && length(A_m83_modified)>1 && length(A_m83_modified{end}) == source*detect
    A_m83 = A_m83_modified{end};
    P_m83 = P_m83_modified{end};
end


AF74=MA74\A_m74';  %MA6 *AF6=A_m6' (A_m6 is log(A*r^2), MA6 is kind of distribution, AF6 is effective point)
PF74=MP74\P_m74';                %AF6's structure correspond to the structure of MA6, first part is about source(1-9)
AF78=MA78\A_m78';                %second part is related to the detector (source+2*detect-1), last one is distance
PF78=MP78\P_m78';
AF80=MA80\A_m80';
PF80=MP80\P_m80';
AF83=MA83\A_m83';
PF83=MP83\P_m83';

AF74=MA74\A_m74';  %MA6 *AF6=A_m6' (A_m6 is log(A*r^2), MA6 is kind of distribution, AF6 is effective point)
PF74=MP74\P_m74';                %AF6's structure correspond to the structure of MA6, first part is about source(1-9)
AF78=MA78\A_m78';                %second part is related to the detector (source+2*detect-1), last one is distance
PF78=MP78\P_m78';
AF80=MA80\A_m80';
PF80=MP80\P_m80';
AF83=MA83\A_m83';
PF83=MP83\P_m83';

AS74=[1;exp(AF74(1:source-1))];  %%%%%%%source only have one part, 1 also from the first source in this design is no use
AD74=exp(AF74(source:source+detect-1));  %this part should relate to the probe design
ki74=-AF74(source+detect);     %seems correspond to k real and k imagine part, 
 
AS78=[1;exp(AF78(1:source-1))];    %%%%%%%%%%%AS is the gain for source
AD78=exp(AF78(source:source+detect-1));  %%AD is the the gain for detector
ki78=-AF78(source+detect);        %%k is close to paper of DANEN

AS80=[1;exp(AF80(1:source-1))];
AD80=exp(AF80(source:source+detect-1));
ki80=-AF80(source+detect);

AS83=[1;exp(AF83(1:source-1))];
AD83=exp(AF83(source:source+detect-1));
ki83=-AF83(source+detect);    

PS74=[0;PF74(1:source-1)];%+ps0';
PD74=PF74(source:source+detect-1);%+pd0';
kr74=PF74(source+detect);

PS78=[0;PF78(1:source-1)];%+ps0';
PD78=PF78(source:source+detect-1);%+pd0';
kr78=PF78(source+detect);

PS80=[0;PF80(1:source-1)];%+ps0';
PD80=PF80(source:source+detect-1);%+pd0';
kr80=PF80(source+detect);

PS83=[0;PF83(1:source-1)];%+ps0';
PD83=PF83(source:source+detect-1);%+pd0';
kr83=PF83(source+detect);

D74 = omega/2/ki74/kr74/vel;   %this D is different with the D in that paper, see note
muabg74 = -(-ki74^2+kr74^2)*D74;
muspbg74 = 1/3/D74  ;       % From that paper, deduction is right,no sign problem , keep kr negetive, ki positive

D78 = omega/2/ki78/kr78/vel;
muabg78 = -(-ki78^2+kr78^2)*D78;
muspbg78 = 1/3/D78 ;%muabg7

D80 = omega/2/ki80/kr80/vel;
muabg80 = -(-ki80^2+kr80^2)*D80;
muspbg80 = 1/3/D80;  %muabg8;

D83 = omega/2/ki83/kr83/vel;
muabg83 = -(-ki83^2+kr83^2)*D83;
muspbg83 = 1/3/D83 ;  %muabg83;

U74 = bgpd(Measmnt74,s_geom,d_geom,muabg74,muspbg74,freq,Refl);  %same with old 
U78 = bgpd(Measmnt78,s_geom,d_geom,muabg78,muspbg78,freq,Refl);
U80 = bgpd(Measmnt80,s_geom,d_geom,muabg80,muspbg80,freq,Refl);
U83 = bgpd(Measmnt83,s_geom,d_geom,muabg83,muspbg83,freq,Refl);

corr_a74=[];
corr_p74=[];
corr_a78=[];
corr_p78=[];
corr_a80=[];
corr_p80=[];
corr_a83=[];
corr_p83=[];


amp_m74=[];
amp_m78=[];
amp_m80=[];
amp_m83=[];

phase_m74=[];
phase_m78=[];
phase_m80=[];
phase_m83=[];


for jj=1:Nmeas74
   si=Measmnt74(jj,1);
   di=Measmnt74(jj,2);
                                                            %PS PD AS AD is the gain for each
    phase_m74(jj)=bgphase74(si,di)-PS74(si)-PD74(di);              % source and detector
   	amp_m74(jj)=bgamp74(si,di)/AS74(si)/AD74(di);
  
    
end

for jj=1:Nmeas78
   si=Measmnt78(jj,1);
   di=Measmnt78(jj,2);
   
    phase_m78(jj)=bgphase78(si,di)-PS78(si)-PD78(di);
   	amp_m78(jj)=bgamp78(si,di)/AS78(si)/AD78(di);
end

for jj=1:Nmeas80
   si=Measmnt80(jj,1);
   di=Measmnt80(jj,2);
   
      phase_m80(jj)=bgphase80(si,di)-PS80(si)-PD80(di); 
      amp_m80(jj)=bgamp80(si,di)/AS80(si)/AD80(di);
end

for jj=1:Nmeas83
   si=Measmnt83(jj,1);
   di=Measmnt83(jj,2);
   
      phase_m83(jj)=bgphase83(si,di)-PS83(si)-PD83(di); 
      amp_m83(jj)=bgamp83(si,di)/AS83(si)/AD83(di);
end

phase_m74=mod(phase_m74,2*pi);
phase_m78=mod(phase_m78,2*pi);
phase_m80=mod(phase_m80,2*pi);
phase_m83=mod(phase_m83,2*pi);


phase_c74=angle(U74);
amp_c74=abs(U74);
phase_c78=angle(U78);
amp_c78=abs(U78);
phase_c80=angle(U80);
amp_c80=abs(U80);
phase_c83=angle(U83);
amp_c83=abs(U83);  
%%%%%%%%%%%compare the phase_c and phase_m, amp_c and amp_m, should be same linearity

phase_diff74=mean(mod((-phase_c74+mod(phase_m74,2*pi)+pi),2*pi)-pi);  % get the correction of system
sys_gain74=exp(mean(log(amp_m74)-log(amp_c74)));
phase_diff78=mean(mod((-phase_c78+mod(phase_m78,2*pi)+pi),2*pi)-pi);
sys_gain78=exp(mean(log(amp_m78)-log(amp_c78)));
phase_diff80=mean(mod((-phase_c80+mod(phase_m80,2*pi)+pi),2*pi)-pi);
sys_gain80=exp(mean(log(amp_m80)-log(amp_c80)));
phase_diff83=mean(mod((-phase_c83+mod(phase_m83,2*pi)+pi),2*pi)-pi);
sys_gain83=exp(mean(log(amp_m83)-log(amp_c83)));

corr_a74=amp_m74./amp_c74/sys_gain74;       %%%%%%  corr_a and corr_p is the crrected experiment value
corr_a78=amp_m78./amp_c78/sys_gain78;
corr_a80=amp_m80./amp_c80/sys_gain80;
corr_a83=amp_m83./amp_c83/sys_gain83;

corr_p74=phase_m74-phase_c74-phase_diff74;
corr_p78=phase_m78-phase_c78-phase_diff78;
corr_p80=phase_m80-phase_c80-phase_diff80;
corr_p83=phase_m83-phase_c83-phase_diff83;

corr_p74=mod(corr_p74+1,2*pi)-1;
corr_p78=mod(corr_p78+1,2*pi)-1;
corr_p80=mod(corr_p80+1,2*pi)-1;
corr_p83=mod(corr_p83+1,2*pi)-1;

temp = polyfit(sddist74(1:Nmeas74),log(amp_c74.*sddist74(1:Nmeas74).^2),1);   %%%%% temp is from the therotical value
corr_ki74 = -temp(1)/ki74;                                                  %%%% using it to adjust the experiment kr ki
temp = polyfit(sddist78(1:Nmeas78),log(amp_c78.*sddist78(1:Nmeas78).^2),1);
corr_ki78 = -temp(1)/ki78;
temp = polyfit(sddist80(1:Nmeas80),log(amp_c80.*sddist80(1:Nmeas80).^2),1);
corr_ki80 = -temp(1)/ki80;
temp = polyfit(sddist83(1:Nmeas83),log(amp_c83.*sddist83(1:Nmeas83).^2),1);
corr_ki83 = -temp(1)/ki83;



temp = polyfit(sddist74(1:Nmeas74),mod(phase_c74,2*pi),1);
corr_kr74 = temp(1)/kr74;
temp = polyfit(sddist78(1:Nmeas78),mod(phase_c78,2*pi),1);
corr_kr78 = temp(1)/kr78;
temp = polyfit(sddist80(1:Nmeas80),mod(phase_c80,2*pi),1);
corr_kr80 = temp(1)/kr80;
temp = polyfit(sddist83(1:Nmeas83),mod(phase_c83,2*pi),1);
corr_kr83 = temp(1)/kr83;

%%%%%%%%%%%%%  get the system parameter (different source detector have different gain, get their distribution)
%and compare experiment value with therotical value, adjust the wave number
%%% for this one, many thing need check first, the total range (cut point), the turnpoint
%%% so first see the total range, whether the value is reasonalble, then change the turnpoint
