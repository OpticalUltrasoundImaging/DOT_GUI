%     set(handles.absmax_740,'String',num2str(absMax74,'%2.3f'));
%     set(handles.absmean_740,'String',num2str(absMean74,'%2.3f'));
%     set(handles.absmax_780,'String',num2str(absMax78,'%2.3f'));
%     set(handles.absmean_780,'String',num2str(absMean78,'%2.3f'));
%     set(handles.absmax_808,'String',num2str(absMax80,'%2.3f'));
%     set(handles.absmean_808,'String',num2str(absMean80,'%2.3f'));
%     set(handles.absmax_830,'String',num2str(absMax83,'%2.3f'));
%     set(handles.absmean_830,'String',num2str(absMean83,'%2.3f'));
app.maxab740.Value = num2str(absMax74,'%2.3f');
app.maxab780.Value = num2str(absMax78,'%2.3f');
app.maxab808.Value = num2str(absMax80,'%2.3f');
app.maxab830.Value = num2str(absMax83,'%2.3f');
app.meanab740.Value = num2str(absMean74,'%2.3f');
app.meanab780.Value = num2str(absMean78,'%2.3f');
app.meanab808.Value = num2str(absMean80,'%2.3f');
app.meanab830.Value = num2str(absMean83,'%2.3f');
if show_absorb == 1
    h = findobj(allchild(0), 'flat', 'Tag','fgMap740');
    if ishandle(h)
        close(h);
    end
    figure('Name','DOT ML 740','Tag','fgMap740');	% #5
    numOfSubplots = size(volume74, 3);
    h_images = zeros(1,numOfSubplots);
    h_axes = zeros(1,numOfSubplots);
    for p = 1:numOfSubplots
        subplot(3,3,p,'align');
        h = imagesc(vy,vx,volume74(:,:,p)',[0 0.2]);
        set(gca,'YDir','Normal');
        colormap(jet);
        axis image;
        colorbar('location','EastOutside');
        title(['Slice ' num2str(p)]);
        set(h,'HitTest','off');

        % h is the handle of image and its parent is the axis
        h_images(p) = h;
        h_axes(p) = get(h,'parent');

        % the source code of this is located in aborption_mapping.m
        set(h_axes(p),'ButtonDownFcn',{@btnAction,h,vx,vy});
    end
    max_ua = max(volume74,[],'all');
    txt = ['Max mua: ' num2str(max_ua)];
    text(20,0,txt,'FontSize',14)

    h = findobj(allchild(0), 'flat', 'Tag','fgMap780');
    if ishandle(h)
        close(h);
    end
    figure('Name','DOT ML 780','Tag','fgMap780');	% #5
    numOfSubplots = size(volume78, 3);
    for p = 1:numOfSubplots
        subplot(3,3,p,'align');
        h = imagesc(vy,vx,volume78(:,:,p)',[0 0.2]);
        set(gca,'YDir','Normal');
        colormap(jet);
        axis image;
        colorbar('location','EastOutside');
        title(['Slice ' num2str(p)]);
        set(h,'HitTest','off');

        % h is the handle of image and its parent is the axis
        h_images(p) = h;
        h_axes(p) = get(h,'parent');

        % the source code of this is located in aborption_mapping.m
        set(h_axes(p),'ButtonDownFcn',{@btnAction,h,vx,vy});
    end
    max_ua = max(volume78,[],'all');
    txt = ['Max mua: ' num2str(max_ua)];
    text(20,0,txt,'FontSize',14)

    h = findobj(allchild(0), 'flat', 'Tag','fgMap808');
    if ishandle(h)
        close(h);
    end
    figure('Name','DOT ML 808','Tag','fgMap808');	% #5
    numOfSubplots = size(volume80, 3);
    for p = 1:numOfSubplots
        subplot(3,3,p,'align');
        h = imagesc(vy,vx,volume80(:,:,p)',[0 0.2]);
        set(gca,'YDir','Normal');
        colormap(jet);
        axis image;
        colorbar('location','EastOutside');
        title(['Slice ' num2str(p)]);
        set(h,'HitTest','off');

        % h is the handle of image and its parent is the axis
        h_images(p) = h;
        h_axes(p) = get(h,'parent');

        % the source code of this is located in aborption_mapping.m
        set(h_axes(p),'ButtonDownFcn',{@btnAction,h,vx,vy});
    end
    max_ua = max(volume80,[],'all');
    txt = ['Max mua: ' num2str(max_ua)];
    text(20,0,txt,'FontSize',14)

    h = findobj(allchild(0), 'flat', 'Tag','fgMap830');
    if ishandle(h)
        close(h);
    end
    figure('Name','DOT ML 830','Tag','fgMap830');	% #5
    numOfSubplots = size(volume83, 3);
    for p = 1:numOfSubplots
        subplot(3,3,p,'align');
        h = imagesc(vy,vx,volume83(:,:,p)',[0 0.2]);
        set(gca,'YDir','Normal');
        colormap(jet);
        axis image;
        colorbar('location','EastOutside');
        title(['Slice ' num2str(p)]);
        set(h,'HitTest','off');

        % h is the handle of image and its parent is the axis
        h_images(p) = h;
        h_axes(p) = get(h,'parent');

        % the source code of this is located in aborption_mapping.m
        set(h_axes(p),'ButtonDownFcn',{@btnAction,h,vx,vy});
    end
    max_ua = max(volume83,[],'all');
    txt = ['Max mua: ' num2str(max_ua)];
    text(20,0,txt,'FontSize',14)
end
    
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
end