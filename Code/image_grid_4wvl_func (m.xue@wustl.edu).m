function [volume] = image_grid_4wvl_func(source_wvl,absorb_value,Nvxls,v_geom,voxel,v_tot,vx,vy,vz,vx1,vy1,vz1,nvx,nvy,flip_state,z_radius,dMua_tot,mua0,Nmeas,weight_a,v_vol_L,actionFlag,v_vol_N,mus0,iter,epsPercent,data)

[volume] = image_grid_data_func(absorb_value,Nvxls,v_geom,voxel,v_tot,vx,vy,vz,vx1,vy1,vz1,nvx,nvy,flip_state);
max_ua = max(volume,[],'all');
switch source_wvl
    case 740
        h = findobj(allchild(0), 'flat', 'Tag','fgMap740');
        if ishandle(h)
            close(h);
        end
        figure('Name','Absorption Maps: 740nm','Tag','fgMap740');
        
    case 780
        h = findobj(allchild(0), 'flat', 'Tag','fgMap780');
        if ishandle(h)
            close(h);
        end
        figure('Name','Absorption Maps: 780nm','Tag','fgMap780');
        
    case 808
        h = findobj(allchild(0), 'flat', 'Tag','fgMap808');
        if ishandle(h)
            close(h);
        end
        figure('Name','Absorption Maps: 808nm','Tag','fgMap808');
        
    case 830
        h = findobj(allchild(0), 'flat', 'Tag','fgMap830');
        if ishandle(h)
            close(h);
        end
        figure('Name','Absorption Maps: 830nm','Tag','fgMap830');
end

numOfSubplots = length(vz);
h_images = zeros(1,numOfSubplots);
h_axes = zeros(1,numOfSubplots);

for p=1:numOfSubplots
    subplot(3,3,p,'align');
    if flip_state==1 %Check to see whether matrix should be flipped
        h = imagesc(vy,vx,fliplr(volume(:,:,p)'),[0 0.2]);
        set(gca,'YDir','Normal');
        colormap(jet);
        axis image;
        colorbar('location','EastOutside');
    else
        h = imagesc(vy,vx,volume(:,:,p)',[0 0.2]);
        set(gca,'YDir','Normal');
        colormap(jet);
        axis image;
        colorbar('location','EastOutside');
    end
    title(['Slice ' num2str(p)]);
    set(h,'HitTest','off');
    
    % h is the handle of image and its parent is the axis
    h_images(p) = h;
    h_axes(p) = get(h,'parent');
    
    % the source code of this is located in aborption_mapping.m
    set(h_axes(p),'ButtonDownFcn',{@btnAction,h,vx,vy,v_geom,vz,z_radius,dMua_tot,mua0,nvx,nvy,vz1,v_tot,Nvxls,voxel,Nmeas,weight_a,v_vol_L,actionFlag,v_vol_N,mus0,iter,epsPercent,vx1,vy1,flip_state,source_wvl,data});
end
txt = ['Max mua: ' num2str(max_ua)];
text(20,0,txt,'FontSize',14)


function btnAction(src,eventdata,imhandle,vx,vy,v_geom,vz,z_radius,dMua_tot,mua0,nvx,nvy,vz1,v_tot,Nvxls,voxel,Nmeas,weight_a,v_vol_L,actionFlag,v_vol_N,mus0,iter,epsPercent,vx1,vy1,flip_state,source_wvl,data)
    location = get(gca,'CurrentPoint');
    absorb = dMua_tot+mua0;
    dMua_tot_orig = dMua_tot;
    if mod(z_radius,0.5) == 0.49
        t_radius = z_radius+0.01; %%0.49/0.99/1.49 --> 0.5,1,1.5
    else
        t_radius = z_radius+0.05; %%0.7 --> 0.75
    end
    x_loc = abs(vx-location(1,1));
    [~,x_idx] = min(x_loc);
    y_loc = abs(vy-location(1,2));
    [~,y_idx] = min(y_loc);
    depth_idx = regexp(src.Title.String,'\d*','Match');
    depth = vz(str2num(depth_idx{1}));
    vsphere = (v_geom(:,1)-vx(x_idx)).^2+(v_geom(:,2)-vy(y_idx)).^2+(v_geom(:,3)-depth).^2;
    tind = vsphere<(3*t_radius)^2;
    max_tar = max(dMua_tot(tind == 1));
    find_ncluster;
    niter = 1;
    pert = data(1:Nmeas) + 1j * data(Nmeas+1:2*Nmeas);
    
    if ncluster > 1
        while ncluster >1 && niter < 10
            for thresh_test = mua0+0.1*max_tar:0.00001:max(volume7_temp(:))
                BW = (volume7_temp>thresh_test);
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
                geom{j} = [vy(yj);vx(xj);vz(zj)]';
                center = mean(geom{j},1);
                dist(j) = ((center(1)-vx(x_idx))^2+(center(2)-vy(y_idx))^2 + (center(3)-depth)^2)^0.5;
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
            weight_Born_new = conj(weight_a');
            AA = dMua_tot(1:v_tot)*v_vol_L;
            BB = dMua_tot((v_tot+1):Nvxls)*v_vol_L;
            pert_new = pert.' - weight_Born_new*[AA;BB];
            data_new = [reshape(real(pert_new)',[Nmeas 1]);reshape(imag(pert_new)',[Nmeas 1])];

            dMua_all = zeros(Nvxls,1);
            if actionFlag == 0      % All
                dMua_tot = conj_TLS_all(dMua_all,data_new,weight_a,Nmeas,Nvxls,v_vol_L,v_vol_N,mua0,mus0,v_tot,iter,epsPercent, 0);
            elseif actionFlag == 1  % Reg
                dMua_tot = conj_TLS_regularized(dMua_all,data_new,weight_a,Nmeas,Nvxls,v_vol_L,v_vol_N,mua0,mus0,v_tot,iter,epsPercent,0);
            elseif actionFlag == 3  % Menghao test
%                 itmax = 15;         % hard-coded for now.  Menghao indicated at least 10 and width_info = [2.2,1.40]; is hard-coded in regShaped.m line 16
%                 [v_loc,~,depth_info] = LayerSeparation(v_geom,z_radius,depth,v_tot);
%                 [regks] = regShaped(depth_info, data, app, source_wvl); % width info come from US segmentation, if not, need manually input
%                 [dMua_tot,~] = Fista(dMua_tot,data',weight_a',Nmeas,Nvxls,v_vol_L, v_vol_N,v_tot,v_loc,regks,itmax,depth);
            else                    % All
                dMua_tot = conj_TLS_all(dMua_all,data_new,weight_a,Nmeas,Nvxls,v_vol_L,v_vol_N,mua0,mus0,v_tot,iter,epsPercent, 0);
            end
%             [dMua_tot, ~] = conj_tls_regu_final(dMua_all, data_new, weight_Born,Nmeas,Nvxls,v_vol_L, v_vol_L,mua0,mus0,v_tot,3,0);
            %   [dMua_tot, object_1]=conj_tls_regu_final(dMua_all, data_new, weight_Born,Nmeas,Nvxls,v_vol_L, v_vol_L,mua0,mus0,v_tot,5*round((object_1(1)/object_1(2)))^2,0);
            absorb_value(1:v_tot)=dMua_tot(1:v_tot);
            absorb_value(v_tot+1:length(v_geom))=dMua_tot(v_tot+1:length(v_geom))+mua0;
            [volume] = image_grid_data_func(absorb_value,Nvxls,v_geom,voxel,v_tot,vx,vy,vz,vx1,vy1,vz1,nvx,nvy,flip_state);
            max_ua = max(volume,[],'all');
            switch source_wvl
                case 740
                    h = findobj(allchild(0), 'flat', 'Tag','fgMap740');
%                     if ishandle(h)
%                         close(h);
%                     end
                    figure('Name','Absorption Maps: 740nm','Tag','fgMap740');

                case 780
                    h = findobj(allchild(0), 'flat', 'Tag','fgMap780');
%                     if ishandle(h)
%                         close(h);
%                     end
                    figure('Name','Absorption Maps: 780nm','Tag','fgMap780');

                case 808
                    h = findobj(allchild(0), 'flat', 'Tag','fgMap808');
%                     if ishandle(h)
%                         close(h);
%                     end
                    figure('Name','Absorption Maps: 808nm','Tag','fgMap808');

                case 830
                    h = findobj(allchild(0), 'flat', 'Tag','fgMap830');
%                     if ishandle(h)
%                         close(h);
%                     end
                    figure('Name','Absorption Maps: 830nm','Tag','fgMap830');
            end
            numOfSubplots = length(vz);
            h_images = zeros(1,numOfSubplots);
            h_axes = zeros(1,numOfSubplots);

            for p=1:numOfSubplots
                subplot(3,3,p,'align');
                if flip_state==1 %Check to see whether matrix should be flipped
                    h = imagesc(vy,vx,fliplr(volume(:,:,p)'),[0 0.2]);
                    set(gca,'YDir','Normal');
                    colormap(jet);
                    axis image;
                    colorbar('location','EastOutside');
                else
                    h = imagesc(vy,vx,volume(:,:,p)',[0 0.2]);
                    set(gca,'YDir','Normal');
                    colormap(jet);
                    axis image;
                    colorbar('location','EastOutside');
                end
                title(['Slice ' num2str(p)]);
                set(h,'HitTest','off');

                % h is the handle of image and its parent is the axis
                h_images(p) = h;
                h_axes(p) = get(h,'parent');

                % the source code of this is located in aborption_mapping.m
                set(h_axes(p),'ButtonDownFcn',{@btnAction,h,vx,vy,v_geom,vz,z_radius,dMua_tot,mua0,nvx,nvy,vz1,v_tot,Nvxls,voxel,Nmeas,weight_a,v_vol_L,actionFlag,v_vol_N,mus0,iter,epsPercent,vx1,vy1,flip_state,source_wvl});
            end
            txt = ['Max mua: ' num2str(max_ua)];
            text(20,0,txt,'FontSize',14)
            
            dMua_tot_orig=dMua_tot;
            absorb = dMua_tot+mua0;
            max_tar = max(dMua_tot(tind == 1));
            pert = pert_new.';
            %     figure
            %     plot(real(pert),imag(pert),'o')
            find_ncluster;
            niter = niter + 1;
        end
    end
