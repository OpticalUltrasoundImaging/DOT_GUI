function [volume] = image_grid_data_func_yz(absorb_value,Nvxls,v_geom,voxel,v_tot,vx,vy,vz,vx1,vy1,vz1,nvz,nvy,flip_state)

layer1=zeros(nvy,nvz);
nvy1=length(vy1);
nvz1 = nvy1;

absorb = absorb_value;
for jj=1:length(vx1)
    xx=find(v_geom(v_tot+1:Nvxls,3)==vx1(jj));
    for i=1:length(xx)
        layer1b(voxel(xx(i)+v_tot,1),voxel(xx(i)+v_tot,2))=absorb(xx(i)+v_tot);
    end
    volume_data(:,:,jj)=layer1b;
    layer1b=zeros(nvy1,nvz1);
end

[X,Y,Z]=meshgrid(vx,vy,vz);

if length(vx) == 1
    volume_data_int=interp2(vy1,vz1,volume_data,Y,Z,'linear'); 
else
    volume_data_int=interp3(vx1,vy1,vz1,volume_data,X,Y,Z,'linear');    %Matlab function: INTERP3 3-D interpolation (table lookup).

end

volume = zeros(size(volume_data_int));
for jj=1:length(vz)
    yy=find(v_geom(1:v_tot,3)==vz(jj));
    for i=1:length(yy)
        layer1(voxel(yy(i),1),voxel(yy(i),2))=absorb(yy(i));
    end
    if isempty(yy)
        volume(:,:,jj)=volume_data_int(:,:,jj);
    else
        volume(:,:,jj)=volume_data_int(:,:,jj)+layer1;
    end
    layer1=zeros(nvx,nvy);
end
