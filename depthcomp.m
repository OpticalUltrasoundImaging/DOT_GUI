
function [weight_a_depth,svd_a, svd_b]=depthcomp(v_geom,weight_a,vz1,vz,Nvxls,v_tot);

%weight_a;
weight_a_depth = zeros(size(weight_a));
%layer=zeros(nvx,nvy);
vz1_s=size(vz1,2);

%back ground computation
for i=1:vz1_s
    x=find(v_geom(v_tot+1:Nvxls,3)==vz1(i));
    temp=weight_a(x+v_tot,:);
    svd_b(i) = svd(temp(:));
end
%svd_b = svd_b./svd_b(1);
%svd_b=svd_b*2;
for i=1:vz1_s
    x=find(v_geom(v_tot+1:Nvxls,3)==vz1(i));
    weight_a_depth (x+v_tot,:)=  weight_a(x+v_tot,:)*svd_b(vz1_s-i+1);
end

vz_s=size(vz,2);
for i=1:vz_s
    y=find(v_geom(1:v_tot,3)==vz(i));
    if isempty(y);%(length(y)~=0);
        svd_a(i)=1;
    else
        temp=weight_a(y,:);
        svd_a(i) = svd(temp(:));
    end
end
svd_a=svd_a(svd_a~=1);
%svd_a=svd_a*2;
%svd_a = svd_a./svd_a(1);
ii=0;
for i=1:vz_s
    y=find(v_geom(1:v_tot,3)==vz(i));
    if isempty(y);
    else
        weight_a_depth (y,:)=  weight_a(y,:)*svd_a(end-ii);
        ii=ii+1;
    end
end
