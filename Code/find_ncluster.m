absorb_temp = absorb;
% absorb_temp(tind == 1)= mua0;
layer=zeros(nvx,nvy);

vz1_s=size(vz1,2);
volume_data=[];
volume7_temp=[];
for i=1:vz1_s
    x=find(v_geom(v_tot+1:Nvxls,3)==vz1(i));
    
    for j=1:length(x)
        
        layerb(voxel(x(j)+v_tot,1),voxel(x(j)+v_tot,2))=absorb_temp(x(j)+v_tot);
        
    end
    volume_data(:,:,i)=layerb;
    clear x;
    
end


[X,Y,Z]=meshgrid(vx,vy,vz);
volume_data_int=interp3(vx1,vy1,vz1,volume_data,X,Y,Z,'nearest'); % back ground add as small mesh
volume_data_int(isnan(volume_data_int))=mua0;

vz_s=size(vz,2);
for i=1:vz_s
        y=find(v_geom(1:v_tot,3)==vz(i));    
    for j=1:length(y)        
        layer(voxel(y(j),1),voxel(y(j),2))=absorb_temp(y(j));
        volume_data_int(voxel(y(j),1),voxel(y(j),2),i)=0;        
    end
    volume7_temp(:,:,i)=volume_data_int(:,:,i)+layer;
    layer=zeros(nvx,nvy);    
end

thresh_test = 0.5*max_tar+mua0;
BW_temp = (volume7_temp > thresh_test);
% figure,
% for p = 1:7
%     subplot(3,3,p)
%     imagesc(vy,vx,BW_temp(:,:,p)')
%     set(gca,'YDir','Normal');
% end
% figure,
% for p = 1:7
%     subplot(3,3,p)
%     imagesc(vy,vx,volume7_temp(:,:,p)')
%     set(gca,'YDir','Normal');
% end
connect = bwconncomp(BW_temp,4);
ncluster = connect.NumObjects;

