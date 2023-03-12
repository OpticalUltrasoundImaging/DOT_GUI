%%%%%%%%%%%%%%%%%%% compute opitcal obsorption map of each wavelength %%%%
function [volume,vx,vy,nvx,nvy,abs_max,abs_mean,v_tot,absorb_value,abs_max_delta,abs_mean_delta]...
	= absorption_mappingSingleTarget (app, xcenter_position,ycenter_position,xy_x_radius,xy_y_radius,z_radius,xy_grid,depth,n_depth,Nmeas,Measmnt,...
	s_geom,d_geom,mua0,mus0,data,source_wvl,flip_state,large_mapping,...
    mua1,mua2,musp1,musp2,layerDepth,two_layer,probe_x,probe_y,probe_z,z_step_value,actionFlag,itmax,epsPercent,show_absorb)

clear v_geom;
clear object;
clear absorb_value;
% n_depth = 2;
% probe_z = 0;
% probe_x = 0;
rtg = [xcenter_position ycenter_position depth];
[Nvxls,v_vol_L,v_vol_N,v_geom,voxel,v_tot,vx,vy,vz,vx1,vy1,vz1,nvx,nvy] = born_sphare1_func(xy_x_radius,xy_y_radius,z_radius,xy_grid,n_depth,rtg,probe_x,probe_y,probe_z,z_step_value);
% [Nvxls,v_vol_L,v_vol_N,v_geom,voxel,v_tot,vx,vy,vz,vx1,vy1,vz1,nvx,nvy] = born_sphare1_func_yz(xy_x_radius,xy_y_radius,z_radius,xy_grid,n_depth,rtg,probe_x,probe_y,probe_z,z_step_value);
%[Nmeas,Measmnt,data] = GMM2D1Cluster(data,Measmnt); % testing for outliers removal and it is no longer needed

%initialization
weight_a = zeros(Nvxls,Nmeas);
weight_D = zeros(Nvxls,Nmeas);

weight_a = born_weight_beta_tilt(Measmnt,Nmeas,s_geom,d_geom,Nvxls,v_geom,weight_a,weight_D,v_vol_L,v_vol_N,mua0,mus0,v_tot,0); 

if large_mapping == 1
    [weight_a_depth,svd_a,svd_b] = depthcomp(v_geom,weight_a,vz1,vz,Nvxls,v_tot);
end

L=[];
iter = itmax;
dMua_tot=zeros(Nvxls,1);

if large_mapping == 1
    weight_a = weight_a_depth;
end

if actionFlag == 0      % All
    dMua_tot = conj_TLS_all(dMua_tot,data',weight_a,Nmeas,Nvxls,v_vol_L,v_vol_N,mua0,mus0,v_tot,iter,epsPercent, 0);
elseif actionFlag == 1  % Reg
    dMua_tot = conj_TLS_regularized(dMua_tot,data',weight_a,Nmeas,Nvxls,v_vol_L,v_vol_N,mua0,mus0,v_tot,itmax,epsPercent,0);
elseif actionFlag == 3  % Menghao test
    itmax = 15;         % hard-coded for now.  Menghao indicated at least 10 and width_info = [2.2,1.40]; is hard-coded in regShaped.m line 16
    [v_loc,~,depth_info] = LayerSeparation(v_geom,z_radius,depth,v_tot);

    [regks] = regShaped(depth_info, data, app, source_wvl); % width info come from US segmentation, if not, need manually input

    [dMua_tot,~] = Fista(dMua_tot,data',weight_a',Nmeas,Nvxls,v_vol_L, v_vol_N,v_tot,v_loc,regks,itmax,depth);

%     [v_loc,num_loc,depth_info] = LayerSeparation(v_geom,z_radius,depth,v_tot);
%     [regks] = regShaped(depth_info);
%     [dMua_tot,object] = Fista(dMua_tot,data,weight_a',Nmeas,Nvxls,v_vol_L, v_vol_N,v_tot,v_loc,regks,itmax,depth);
else                    % All
    dMua_tot = conj_TLS_all(dMua_tot,data',weight_a,Nmeas,Nvxls,v_vol_L,v_vol_N,mua0,mus0,v_tot,iter,epsPercent, 0);
end

if large_mapping == 1
    vz1_s=size(vz1,2);
    for i=1:vz1_s
        x=find(v_geom(v_tot+1:Nvxls,3)==vz1(i));
        dMua_tot(x+v_tot,:)=dMua_tot(x+v_tot,:)*svd_b(vz1_s-i+1);
    end
    vz_s = size(vz,2);
    ii=0;
    for i=1:vz_s
        y=find(v_geom(1:v_tot,3)==vz(i));
        if isempty(y)
        else
            dMua_tot(y,:)=dMua_tot(y,:)*svd_a(end-ii);
            ii=ii+1;
        end
    end
end

absorb_value(1:v_tot)=dMua_tot(1:v_tot);
absorb_value(v_tot+1:length(v_geom))=dMua_tot(v_tot+1:length(v_geom))+mua0;

%source code for the figure and its subplots.  It includes the defination code of three
%action buttons, which are line, ROI and clear, on the subplots. Their
%related callbacks are listed below.
%[volume] = image_grid_4wvl_func740(source_wvl,absorb_value,Nvxls,v_geom,voxel,v_tot,vx,vy,vz,vx1,vy1,vz1,nvx,nvy,flip_state);
if show_absorb == 1
    [volume] = image_grid_4wvl_func(source_wvl,absorb_value,Nvxls,v_geom,voxel,v_tot,vx,vy,vz,vx1,vy1,vz1,nvx,nvy,flip_state,z_radius,dMua_tot,mua0,Nmeas,weight_a,v_vol_L,actionFlag,v_vol_N,mus0,iter,epsPercent,data,app);
else
    [volume] = image_grid_data_func(absorb_value,Nvxls,v_geom,voxel,v_tot,vx,vy,vz,vx1,vy1,vz1,nvx,nvy,flip_state);
end
[abs_max_delta,abs_mean_delta,absorb_value] = absorp_tot(absorb_value, v_tot, 0); 	% need to be in front max and mean
[abs_max,abs_mean,absorb_value] = absorp_tot(absorb_value, v_tot, mua0);			% need to be behind delta

L=[L max(max(max(volume)))];

function btnAction(src,eventdata,imhandle,vx,vy)
h = findobj(gcf,'Tag','clearBtn');
set(h,'Enable','on');

imageActionFor = get(gcf,'userData');   % the figure which has 7 subplot images

if imageActionFor.line == 1             % default.  The line measure button was clicked

    h = imline(gca);
    set(h,'Tag','MLine');
    api = iptgetapi(h);

    % Add a new position callback to set the text string
    api.addNewPositionCallback(@newPos_Callback_line);

    % Fire callback so we get initial text
    newPos_Callback_line(api.getPosition());
else

    cdata = get(imhandle,'CData');
    minValue = min(min(cdata));
    mindata = ones(17) .* minValue;     % set mean value image background

    myData.imhandle = imhandle;         % figure's userData holds the data needed for the new pop up and its reset
    myData.vx = vx;
    myData.vy = vy;
    myData.minValue = minValue;

    fgHandle = figure('Name','Detail Map','Tag','fgDetailMap');
    subplot(2,1,1,'align');
    h = imagesc(vy,vx,cdata,[0 0.2]);
	 colormap(jet);
    axis image;
    colorbar('location','EastOutside');
    title('Original Image');
    set(h,'HitTest','off');
    set(gca,'Tag','detailMapAxis','ButtonDownFcn',@btnActionForROI);

    subplot(2,1,2,'align');             % subplot for the mean values
    h = imagesc(vy,vx,mindata,[0 0.2]);
	 colormap(jet);
    axis image;
    colorbar('location','EastOutside');
    title('Mean Value Image');
    set(h,'HitTest','off');

    myData.meanImageHandle = h;
    set(fgHandle,'userData',myData);

    uicontrol('Style', 'pushbutton', ...
        'String','Clear', ...
        'Position',[400 20 80 30], ...
        'Tag','clearROIBtn', ...
        'Callback','clear_popupimage');     % Pushbutton string callback that calls a MATLAB function

    fgColor = get(gcf,'color');

    uicontrol('Style','text','backgroundColor',fgColor,'FontSize',8, ...
        'Position',[490 16 120 30], ...
        'Tag','roiMaxValue');
    uicontrol('Style','text','backgroundColor',fgColor,'FontSize',8, ...
        'Position',[580 16 120 30], ...
        'Tag','roiMeanValue');
    
end

function btnActionForROI(src,eventdata)
h = imrect(gca);                % only the first axis can receive the click
set(h,'Tag','POPUPROI');
api = iptgetapi(h);

%% Add a new position callback to set the text string
api.addNewPositionCallback(@newPos_Callback_roi);

%% Fire callback so we get initial text
newPos_Callback_roi(api.getPosition());
% end of btnActionForROI

function newPos_Callback_line(newPos)
% Display the current point position in a text label
dist = sqrt((newPos(1,1)-newPos(2,1))^2+(newPos(1,2)-newPos(2,2))^2);
h_text1 = findobj(gcf,'Tag','text1');
h_text2 = findobj(gcf,'Tag','text2');
text1 = get(h_text1,'string');
text2 = get(h_text2,'string');

if ~isempty(text1) && ~isempty(text2)
    set(h_text1,'string', num2str(dist,'% 2.3f'));
    set(h_text2,'string', '');
else
    if isempty(text1)
        set(h_text1,'string', num2str(dist,'% 2.3f'));
    else
        set(h_text2,'string', num2str(dist,'% 2.3f'));
    end 
end
    
% end of newPos_Callback_line

function newPos_Callback_roi(pos)    % pos is a 1-by-4 array [xmin ymin width height].
smallcdata = getXYGrid(pos);

roiMaxValue = max(max(smallcdata.data));

ind = find(smallcdata.data > (roiMaxValue * 0.5));
roiMeanValue = mean(smallcdata.data(ind));

ind = find(smallcdata.data < roiMeanValue);
smallcdata.data(ind) = smallcdata.minValue; %0.2 for debug

mindata = ones(17) .* smallcdata.minValue;
mindata(smallcdata.ygrid,smallcdata.xgrid,:) = smallcdata.data;
set (smallcdata.meanImageHandle,'CData',flipud(fliplr(mindata)));

h_text = findobj(gcf,'Tag','roiMaxValue');
set(h_text,'string', num2str(roiMaxValue,'% 2.3f'));

h_text = findobj(gcf,'Tag','roiMeanValue');
set(h_text,'string', num2str(roiMeanValue,'% 2.3f'));
% end of newPos_Callback_roi

function checkAction(src,eventdata,whichBtn)
if strcmpi(whichBtn,'lineBtn')
    imageActionFor.line = 1;
    imageActionFor.roi = 0;
else
    imageActionFor.line = 0;
    imageActionFor.roi = 1;
end

set(gcf,'userData',imageActionFor);

%============================================================================
% Create the smallest rectangular grid around the ROI which is an imrect
% object at this time.  The range is from -4 to 4 on both x and y.
%==========================================================================
function smallcdata = getXYGrid(pos)    % pos is a 1-by-4 array [xmin ymin width height].

myData = get(gcf,'userData');

imhandle = myData.imhandle;
vx = myData.vx;
vy = myData.vy;

xmax = pos(1) + pos(3);
ymax = pos(2) + pos(4);

if vx(1) > vx(end)
    vx = vx(end:-1:1);
end;

if vy(1) > vy(end)
    vy = vy(end:-1:1);
end;

xmingrid = 1;
xmaxgrid = length(vx);
ymingrid = 1;
ymaxgrid = length(vy);

%xmingrid = find(vx <= pos(1),1,'last');
%xmaxgrid = find(vx >= xmax,1,'first');
%ymingrid = find(vy <= pos(2),1,'last');
%ymaxgrid = find(vy >= ymax,1,'first');

for i = 2 : length(vx)  % pos(1) is xmin
    if pos(1) >= vx(i-1) && pos(1) <= vx(i)
        xmingrid = i - 1;
        break;
    end
end;

for i = 2 : length(vx)  % pos(1) + pos(3) is xmax
    if xmax >= vx(i-1) && xmax <= vx(i)
        xmaxgrid = i;
        break;
    end
end;

for i = 2 : length(vy)  % pos(2) is ymin
    if pos(2) >= vy(i-1) && pos(2) <= vy(i)
        ymingrid = i - 1;
        break;
    end
end;

for i = 2 : length(vy)
    if ymax >= vy(i-1) && ymax <= vy(i)
        ymaxgrid = i;
        break;
    end
end;

xgrid = xmingrid : xmaxgrid;
ygrid = ymingrid : ymaxgrid;
cdata = flipud(fliplr(get(imhandle, 'CData')));

smallcdata.data = double(cdata(ygrid,xgrid,:));
smallcdata.ygrid = ygrid;
smallcdata.xgrid = xgrid;
smallcdata.minValue = myData.minValue;
smallcdata.imageHandle = myData.imhandle;
smallcdata.meanImageHandle = myData.meanImageHandle;
