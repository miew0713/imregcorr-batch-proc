function [res, rate]= batchTesting(Dataset, para)
    % �ѼƳ]�w
    err_threshold= 40;
    
    % �Ѽƽվ�
    if ~exist('para','var')
        para= 1;
    end
    
    % �ܼƪŶ�
    numSuccess= 0;
    numTesting= 0;
    index= 1;
    
    % Ū����ƶ�
    if isnumeric(para)
        % �ȹ��@�i�Ϥ����
        for i= 1:length(Dataset)
            if i==para, continue; end
            [Suc, Err]= testing(para, i);
            
            res{index}.fix= Dataset(para).name;
            res{index}.mov= Dataset(i).name;
            res{index}.success= Suc;
            res{index}.error= Err;
            
            numTesting= numTesting+1;
            index= index+1;
            if Suc, numSuccess= numSuccess+1; end
        end
    else
        % ��Ʈw�椬���
        for i= 1:length(Dataset)
            for j= 1:length(Dataset)
                if j==i, continue; end
                [Suc, Err]= testing(i, j);
                
                res{index}.fix= Dataset(i).name;
                res{index}.mov= Dataset(j).name;
                res{index}.success= Suc;
                res{index}.error= Err;

                numTesting= numTesting+1;
                index= index+1;
                if Suc, numSuccess= numSuccess+1; end
            end
        end
    end
    
    rate= numSuccess/ numTesting *100;
    res= cell2mat(res);
    
    fprintf('�ǽT�v%.1f%%\n',rate);
    
    %% ------------------------------
    function [Suc, Err]= testing(patIdx, sampleIdx)
        %-���o�����᪺�y���I��m-----------
        info= imgRegistration(Dataset(patIdx).img, Dataset(sampleIdx).img);
        transPoints= transformPointsForward(info.tform, Dataset(sampleIdx).corner);
        
        %-�������\T/F�P�w�B---------------
        Err= norm(transPoints-Dataset(patIdx).corner);
        Suc= Err < err_threshold;
        
    end
end