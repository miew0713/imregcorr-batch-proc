function gtruth= setPoints(filename)
    % 顯示圖片
    if isa(filename,'uint8')
        img= filename;
    elseif isa(filename,'double') || isa(filename,'single')
        img= uint8(filename);
    else
        img= imread(filename);        
    end
    
    fig= figure;
    imshow(img);
    hold on;
    
    % 參數設定
    mSize= norm(size(img)) *.02;
    
    % 點擊設定資訊
    while(1)
        % 四角
        title('依序設定四角位置');
        pt= ginput(4);
        plot_pt= plot(pt(:,1), pt(:,2), 'r.', 'markersize', mSize);
        
        % 上邊
        title('選擇上邊界方向，或按Enter重新定位四角');
        dir= ginput(1);
        delete(plot_pt);
        if ~isempty(dir)
            break;
        end
    end
    
    % 計算上邊位置
    pt0= [pt; pt(1,:)];
    dist0= sum(bsxfun(@minus,dir,pt0).^2,2);
    [~,dir]= min(dist0(1:4,:)+dist0(2:5,:));
    
    % 計算上邊方向向量
    topCenter= mean(pt0(dir:(dir+1),:));
    vec= topCenter -mean(pt);
    vec= vec./norm(vec);
    
    % 顯示結果
    title('標記完成，2秒後關閉視窗');
    dirLine= [ topCenter;
               topCenter+vec*mSize*5 ];
    plot(pt0(:,1), pt0(:,2), 'r-', 'linewidth', mSize/6);
    plot(dirLine(:,1), dirLine(:,2), 'r-', 'linewidth', mSize/6);
    plot(dirLine(2), dirLine(4), 'r.', 'markersize', mSize*2);

    % 調整並輸出資料
    pt= [pt; pt];
    pt= pt(dir:(dir+3),:);
    
    gtruth.img= img;
    gtruth.corner= pt;
    gtruth.up= vec;
    
    % 關閉視窗
    pause(1.5);
    close(fig);
end

