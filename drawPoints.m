function drawPoints(gtruth, img)
    if isfield(gtruth,'transPts') && isfield(gtruth,'transUp') && exist('img','var')
        gtruth.img= img;
        gtruth.corner= gtruth.transPts;
        gtruth.up= gtruth.transUp;
    end
    if ~isfield(gtruth,'img') || ~isfield(gtruth,'corner') || ~isfield(gtruth,'up')
        error('輸入結構不正確');
    end
    
    mSize= norm(size(gtruth.img))/300;
    pt0= [gtruth.corner; gtruth.corner(1,:)];
    tc= mean(pt0(1:2,:));
    te= tc+ gtruth.up*mSize*30;
    
    figure;
    imshow(gtruth.img);
    hold on;
    
    plot(pt0(:,1), pt0(:,2), 'r-', 'linewidth', mSize);
    plot([tc(1) te(1)], [tc(2) te(2)], 'r-', 'linewidth', mSize);
    plot(te(1), te(2), 'r.', 'markersize', mSize*12);
    
    hold off;
end