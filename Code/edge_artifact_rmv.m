function [] = edge_artifact_rmv(data,Measmnt,mua0,mus0,z_radius,depth,s_geom,d_geom, xcenter)
vel_c=3e10;
freq=140;
n_ref=1.33333;
vel = vel_c/n_ref; %speed of light in medium in cm
omega = 2.0*pi*freq*1e6;% light modulation frequency
if mod(z_radius,0.5) == 0.49
    t_radius = z_radius+0.01; %%0.49/0.99/1.49 --> 0.5,1,1.5
else
    t_radius = z_radius+0.05; %%0.7 --> 0.75
end

yp=0;%input('y axis position is:');
xp=0;%input('x axis position is:');
layer_n=7;%input('express in how many layer:');  %%%%%  better to keep
rtg=[xp yp depth];
xy_x_radius = 4.5;
xy_y_radius = 4.5;
radius=[xy_x_radius xy_y_radius z_radius];
n_depth= rem(depth-t_radius,0.5);  %%% depth of the first layer
if n_depth < 0.2
    n_depth = 0.5+n_depth;
end

if n_depth == depth
    n_depth = depth - 0.5;
end
toplay = (depth-t_radius-n_depth)/0.5+2;
BornSphere;% get image voxel mesh

Nmeas = size(Measmnt,1);
weight_a1=zeros(Nvxls,Nmeas);
weight_D1=zeros(Nvxls,Nmeas);
weight_Born=BornWeights(Measmnt,Nmeas, s_geom,d_geom,Nvxls,v_geom,weight_a1,weight_D1,omega, vel, v_vol_s, v_vol_L,mua0,mus0,v_tot,0);

dMua_all=zeros(Nvxls,1);
[dMua_tot, ~]=conj_tls_regu_final(dMua_all, data', weight_Born,Nmeas,Nvxls,v_vol_s, v_vol_L,mua0,mus0,v_tot,3,0);
absorb=dMua_tot+mua0;ImageGrid;
dMua_tot_orig=dMua_tot;

vsphere = v_geom(:,1).^2+v_geom(:,2).^2+(v_geom(:,3)-depth).^2;
tind = vsphere<(3*t_radius)^2;
max_tar = max(dMua_tot(tind == 1));
find_ncluster;
niter = 1;
pert = data(1:Nmeas) + 1j * data(Nmeas+1:2*Nmeas);

if ncluster > 1
    while ncluster >1 && niter < 10
        for thresh_test = mua0+0.1*max_tar:0.00001:max(volume7(:))
            BW = (volume7>thresh_test);
            connect = bwconncomp(BW);
            thresh = thresh_test ;
            if connect.NumObjects == ncluster
                break;
            end
        end
        if connect.NumObjects ~= ncluster
            break;
        end
        dist = zeros(ncluster,1);
        geom = cell(ncluster,1);
        for j = 1:ncluster
            [xj,yj,zj]=ind2sub([33,33,7],connect.PixelIdxList{1, j} );
            geom{j} = [vx(xj);vy(yj);vz(zj)]';
            center = mean(geom{j},1);
            dist(j) = ((center(1)-xcenter)^2+center(2)^2 + (center(3)-depth)^2)^0.5;
        end
        
        rmv_j = find(dist > min(dist));
        rmv_geom = [];
        for k = 1:length(rmv_j)
            rmv_geom = [rmv_geom;geom{rmv_j(k)}];
        end
        [C,index_rmv,~] = intersect(v_geom,rmv_geom,'rows');
        v_tot_rmv = length(index_rmv);
        dMua_rmv = dMua_tot_orig;
        dMua_rmv(index_rmv) = 0;
        dMua_tot = dMua_tot_orig - dMua_rmv;
        weight_Born_new = conj(weight_Born');
        AA = dMua_tot(1:v_tot_s)*v_vol_s;
        BB = dMua_tot((v_tot_s+1):Nvxls)*v_vol_L;
        pert_new = pert.' - weight_Born_new*[AA;BB];
        data_new = [reshape(real(pert_new)',[Nmeas 1]);reshape(imag(pert_new)',[Nmeas 1])];
        
        dMua_all=zeros(Nvxls,1);
        [dMua_tot, ~]=conj_tls_regu_final(dMua_all, data_new, weight_Born,Nmeas,Nvxls,v_vol_s, v_vol_L,mua0,mus0,v_tot,3,0);
        %   [dMua_tot, object_1]=conj_tls_regu_final(dMua_all, data_new, weight_Born,Nmeas,Nvxls,v_vol_s, v_vol_L,mua0,mus0,v_tot,5*round((object_1(1)/object_1(2)))^2,0);
        dMua_tot_orig=dMua_tot;
        absorb=dMua_tot+mua0;ImageGrid;
        max_tar = max(dMua_tot(tind == 1));
        pert = pert_new.';
        %     figure
        %     plot(real(pert),imag(pert),'o')
        find_ncluster;
        niter = niter + 1;
    end
end

