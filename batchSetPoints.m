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
    
    % Ū���ɮײM��
    FNs= dir(folder_name);
    FNs= {FNs.name};
    
    % �ܼƪŶ�
    img_ext= '(jpg|tif|bmp)$';
    Index= 1;
    
    % ���R�BŪ��
    for i= 1:length(FNs)
        name= FNs{i};
        if isempty(regexp(name,img_ext,'once'))
            continue;
        end
        
        Dataset{Index}= setPoints([folder_name,name]);
        Index= Index+1;
    end
    
    % �s��
    if Index==1
        warning('�Ӹ��|�S�����Ϥ�');
    else
        fprintf('�аO�F%d�i�Ϥ�\n',Index-1);
        save(dataset_name, 'Dataset');
    end
end