%Calculates the photon densities for semi-infinit geometry
% born weights calculation

function U0 = bgpd(Measmnt,s_geom,d_geom,mua0,mus0,freq,Refl);
%global ikw

%GF: 	Normalized Green's funtion and its derivatives at r0. It's a matrix of Nmeas by 10. The first column is the Green's fuction
%		for different S-D pairs; the next three columns are gradient components (d/dx,d/dy,d/dz); the remaining columns
% 		are second order derivatives (d2/dx2,d2/dy2,d2/dz2,d2/dx/dy,d2/dx/dz,d2/dy/dz).
%Measmnt:	A subset of total S-D pairs which provide useful measurements. It's a Nmeas by 2 matrix
%s_geom:		A matrix defining the geometry of sources
%d_geom:		Detector geometry matrix
%r0:	The center point coordinates (xo,y0,z0)
%mua0:	The absorption coefficient of media
%mus0:	The scattering coefficent of media
%freq: 	Freqeucy in MegaHertz


vel_c = 2.99792458e+10; %speed of light in vacum in cm
n_ref = 1.3333; %refractive index in medium
vel = vel_c/n_ref; %speed of light in medium in cm
omega = 2.0*pi*freq*1000000; %2pi freq

Nmeas = size(Measmnt,1);	%Number of measurements

ztr = 1/(mus0+mua0);	%Mean free tranport length or 1/mus0
D0=ztr/3;	%Diffusion coefficient	
ikw = j*sqrt((-mua0+j*omega/vel)/D0);	%Wave number by -j


semi_inf = 1;

%Refl =0; %no index mismatch due to black pad %Change this part for semi-infinite of reflection boundary
zb= 2.0*ztr*(1+Refl)/(3.0*(1.0-Refl));%this zb is shown in Danen's paper

g0=[];

U0=[];
%for  m=1:Nmeas %loop thru measurements
 for m = 1:Nmeas
   s = Measmnt(m,1); %source
   d = Measmnt(m,2); %detector   %effective source-detector pair
   
      s_geom_1(1:3)=s_geom(s,:);
      s_geom_1(3)=s_geom_1(3)+ztr;  %source is ztr into the medium
 
      s_image(1:3)=s_geom_1(:);
      s_image(3)= -s_image(3)-2*zb;
      
     
      tem=d_geom(d,1:3)- s_geom_1(1:3);
      r_sd = tem*tem';
      sddist_squ(m)=r_sd;
      sddist(m)=sqrt(r_sd);

    
      tem = d_geom(d,1:3) - s_image(1:3);
      r_isd = tem*tem';
      
      
      r_sd = sqrt(r_sd);
      r_isd = sqrt(r_isd);
   
      U0_d1 = exp(ikw*r_sd)/r_sd; %U0(homogenous wave) at the detector
      
      abs_factr = -1/D0;
      scat_factr = abs_factr;

      if semi_inf == 1
        U0_d1 = U0_d1-exp(ikw*r_isd)/r_isd;
      end
      U0_d1 = U0_d1/(4*pi*D0);  %more strictly, need v here, 1/4*pi*D0*v
      
      U0(m)=U0_d1;

      %loop thru voxels
   
end  %end of m loop  
%%%%%%get the intensity and phase from the therotical form, use this to adjust system


