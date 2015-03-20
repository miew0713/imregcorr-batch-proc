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
            res{index}= saveResult(para, i);
            numTesting= numTesting+1;
            if res{index}.success, numSuccess= numSuccess+1; end
            index= index+1;
        end
    else
        % ��Ʈw�椬���
        for i= 1:length(Dataset)
            for j= 1:length(Dataset)
                if j==i, continue; end
                res{index}= saveResult(i, j);
                numTesting= numTesting+1;
                if res{index}.success, numSuccess= numSuccess+1; end
                index= index+1;
            end
        end
    end
    
    rate= numSuccess/ numTesting *100;
    res= cell2mat(res);
    
    fprintf('�ǽT�v%.1f%%\n',rate);
    
    %% ------------------------------
    function [Suc, Err, transPoints]= testing(patIdx, sampleIdx)
        %-���o�����᪺�y���I��m-----------
        info= imgRegistration(Dataset(patIdx).img, Dataset(sampleIdx).img);
        transPoints= transformPointsForward(info.tform, Dataset(sampleIdx).corner);
        
        %-�������\T/F�P�w�B---------------
        Err= norm(transPoints-Dataset(patIdx).corner);
        Suc= Err < err_threshold;
        
    end

    %% ------------------------------
    function R= saveResult(patIdx, sampleIdx)
        R.fix= Dataset(patIdx).name;
        R.mov= Dataset(sampleIdx).name;
        [R.success, R.errVal, R.transPts]= testing(patIdx, sampleIdx);
        
        vec= mean(R.transPts(1:2,:)) - mean(R.transPts);
        R.transUp= vec ./ norm(vec);
    end
end