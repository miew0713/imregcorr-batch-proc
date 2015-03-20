function gtruth= setPoints(filename)
    % ��ܹϤ�
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
    
    % �ѼƳ]�w
    mSize= norm(size(img)) *.02;
    
    % �I���]�w��T
    while(1)
        % �|��
        title('�̧ǳ]�w�|����m');
        pt= ginput(4);
        plot_pt= plot(pt(:,1), pt(:,2), 'r.', 'markersize', mSize);
        
        % �W��
        title('��ܤW��ɤ�V�A�Ϋ�Enter���s�w��|��');
        dir= ginput(1);
        delete(plot_pt);
        if ~isempty(dir)
            break;
        end
    end
    
    % �p��W���m
    pt0= [pt; pt(1,:)];
    dist0= sum(bsxfun(@minus,dir,pt0).^2,2);
    [~,dir]= min(dist0(1:4,:)+dist0(2:5,:));
    
    % �p��W���V�V�q
    topCenter= mean(pt0(dir:(dir+1),:));
    vec= topCenter -mean(pt);
    vec= vec./norm(vec);
    
    % ��ܵ��G
    title('�аO�����A2�����������');
    dirLine= [ topCenter;
               topCenter+vec*mSize*5 ];
    plot(pt0(:,1), pt0(:,2), 'r-', 'linewidth', mSize/6);
    plot(dirLine(:,1), dirLine(:,2), 'r-', 'linewidth', mSize/6);
    plot(dirLine(2), dirLine(4), 'r.', 'markersize', mSize*2);

    % �վ�ÿ�X���
    pt= [pt; pt];
    pt= pt(dir:(dir+3),:);
    
    gtruth.img= img;
    gtruth.corner= pt;
    gtruth.up= vec;
    
    % ��������
    pause(1.5);
    close(fig);
end

