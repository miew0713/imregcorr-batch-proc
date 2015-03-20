function batchSetPoints(folder_name, dataset_name)
    if ~exist('folder_name','var')
        folder_name= cd;
    end
    
    if ~exist('dataset_name','var')
        dataset_name= sprintf('dataset%s',datestr(now,'mmddHHMMSS'));
    end
    
    if ispc()
        if isempty(regexp(folder_name,'\$','once'))
            folder_name= [folder_name,'\'];
        end
    else
        if isempty(regexp(folder_name,'/$','once'))
            folder_name= [folder_name,'/'];
        end
    end
    
    % 讀取檔案清單
    FNs= dir(folder_name);
    FNs= {FNs.name};
    
    % 變數空間
    img_ext= '(jpg|tif|bmp)$';
    Index= 1;
    
    % 分析、讀檔
    for i= 1:length(FNs)
        name= FNs{i};
        if isempty(regexp(name,img_ext,'once'))
            continue;
        end
        
        Dataset{Index}= setPoints([folder_name,name]);
        Index= Index+1;
    end
    
    % 存擋
    if Index==1
        warning('該路徑沒有找到圖片');
    else
        fprintf('標記了%d張圖片\n',Index-1);
        save(dataset_name, 'Dataset');
    end
end