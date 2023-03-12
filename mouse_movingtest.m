figure
im = mapshow('boston.tif')
ax = gca;
im.PickableParts = 'none';
ax.ButtonDownFcn = @mouseClick;
function mouseClick(~,~)
    get(gca,'CurrentPoint')
end