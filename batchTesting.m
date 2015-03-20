function [res, rate]= batchTesting(Dataset, para)
    % 參數設定
    err_threshold= 40;
    
    % 參數調整
    if ~exist('para','var')
        para= 1;
    end
    
    % 變數空間
    numSuccess= 0;
    numTesting= 0;
    index= 1;
    
    % 讀取資料集
    if isnumeric(para)
        % 僅對單一張圖片比對
        for i= 1:length(Dataset)
            if i==para, continue; end
            res{index}= saveResult(para, i);
            numTesting= numTesting+1;
            if res{index}.success, numSuccess= numSuccess+1; end
            index= index+1;
        end
    else
        % 資料庫交互比對
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
    
    fprintf('準確率%.1f%%\n',rate);
    
    %% ------------------------------
    function [Suc, Err, transPoints]= testing(patIdx, sampleIdx)
        %-取得對應後的座標點位置-----------
        info= imgRegistration(Dataset(patIdx).img, Dataset(sampleIdx).img);
        transPoints= transformPointsForward(info.tform, Dataset(sampleIdx).corner);
        
        %-對應成功T/F判定、---------------
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