%Calculates the complex weights and the homogenous wave Uo at the detector
% born weights calculation (normalized to the incident waves

function weight_a = born_weight_beta_tilt(Measmnt,NmeasT,s_geom,d_geom,Nvxls,v_geom,weight_a,weight_D,v_vol_L,v_vol_N,mua0,mus0,v_tot,Refl)
%background data from fitting results

ztr = 1/(mus0+mua0);	%Mean free tranport length
D0=ztr/3;	%Diffusion coefficient
ikw = 1i*sqrt((-mua0+1i*Const.omega/Const.vel)/D0);	%Wave number by -j

Uo_d=zeros(NmeasT,1);
Do = ztr/3;
r_sd = 0; % Distance between source and detector
r_isd = 0; %Distance between image source and detector
r_sv = 0; %Distance between source and voxel
r_isv = 0; %Distance between image source and voxel
r_vd = 0; %Distance between voxel and detector
r_ivd = 0; %Distance between image_voxel and detector

semi_inf = 1;
ztr= 1/(mus0+mua0);
Refl = 0; %no index mismatch due to black pad
zb = 2.0*ztr*(1+Refl)/(3.0*(1.0-Refl));%this zb is shown in Robert's paper

%for  m=1:Nmeas %loop thru measurements
for m = 1:NmeasT
    s = Measmnt(m,1); %source
    d = Measmnt(m,2); %detector
    
    s_geom_1(1:3)=s_geom(s,:);
    s_geom_1(3)=s_geom_1(3)+ztr;  %source is ztr into the medium

    s_image(1:3)=s_geom_1(:);
    s_image(3)= -s_image(3)-2*zb;  %image source position
    
    tem=d_geom(d,1:3)- s_geom_1(1:3);
    r_sd = tem*tem';
    
    tem = d_geom(d,1:3) - s_image(1:3);
    r_isd = tem*tem';
    
    r_sd = sqrt(r_sd);
    r_isd = sqrt(r_isd);
    
    Uo_d1 = exp(ikw*r_sd)/r_sd; %Uo(homogenous wave) at the detector
    
    abs_factr = -1/Do;
    
    if semi_inf == 1
        Uo_d1 = Uo_d1-exp(ikw*r_isd)/r_isd;
    end
    
    Uo_d1 = Uo_d1/(4*pi*Do);
    Uo_d(m)=Uo_d1;
    
    %loop thru voxels
     for v=1:Nvxls
        
        v_image(1:3) = v_geom(v,1:3);
        v_image(3) = -v_image(3)-2*zb;  %-ztr;
        
        %distances between source (image) and voxel, and between voxel(image) and detector.
        temp_sv = v_geom(v,1:3) - s_geom_1(1:3);
        temp_isv = v_geom(v,1:3) - s_image(1:3);
        temp_vd =  d_geom(d,1:3) - v_geom(v,1:3) ;
        
        temp_siv = v_image(1:3) - s_geom_1(1:3);
        temp_isiv = v_image(1:3) - s_image(1:3);
        temp_ivd = d_geom(d,1:3) - v_image(1:3);
        
        r_sv = temp_sv*temp_sv';
        r_isv = temp_isv*temp_isv';
        r_vd = temp_vd*temp_vd';
        
        r_siv = temp_siv*temp_siv';
        r_isiv = temp_isiv* temp_isiv';
        r_ivd = temp_ivd*temp_ivd';
        
        r_sv = sqrt(r_sv);
        r_isv = sqrt(r_isv);
        r_vd  = sqrt(r_vd);
        r_ivd = sqrt(r_ivd);
        r_siv =sqrt(r_siv);
        r_isiv =sqrt(r_isiv);
        
        Uo_v = exp(ikw*r_sv)/r_sv;          % s-v
        Uoi_v = -exp(ikw*r_isv)/r_isv;      % image source is-v
        Green = exp(ikw*r_vd)/r_vd;         % v-d
        Green_i= exp(ikw*r_ivd)/r_ivd;      %image voxel iv-d
        Uo_iv = exp(ikw*r_siv)/r_siv;       %source  image voxels-iv
        Uoi_iv = -exp(ikw*r_isiv)/r_isiv;   %image source is-iv

        %%%%%%
        UG_v = ((Uo_v+Uoi_v)*Green+(Uo_iv+Uoi_iv)*Green_i)/(4*pi)/(4*pi*D0);
        
        weight_a(v,m) = abs_factr*UG_v/Uo_d(m);
    end %end of v loop
end  %end of m loop


