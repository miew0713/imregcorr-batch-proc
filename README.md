##setPoints
設定目標追蹤圖樣的位置及方向

> gtruth= setPoints(file [*,para*])

##### 輸入格式
- `file` 圖片或檔案名稱
- `para` 附加參數

	> *-batch* 用於批次設定

##### 輸出格式
struct `gtruth`

- `.img` 圖片
- `.corner` 四角座標，以[x, y]排列
- `.up` 指定的「上」的方向向量

##### 操作
1. 依序（順時針或逆時針）點擊要追蹤的四個角
2. 檢視結果是否正確，歪了就按`Enter`重來
3. 沒問題就點擊物體的「上方」（對物體而言）的位置

##drawPoints
重新畫出`setPoints`回傳的資料或是`batchTesting`對齊之後的結果

#####輸入資料
> drawPoints(para1 [*,para2*])

- *第一個參數* 從 *setPoints* 回傳的結構或是 *batchTesting* 回傳的資料
- *第二個參數* 因為 *batchTesting* 留下的結構不含圖片，自行補上fix的圖片


##batchSetPoints
批次操作`setPoints`
> Dataset= batchSetPoints(folder\_name [*,dataset\_name*])

#####輸入資料
- `folder_name` 圖片所在路徑名稱
- `dataset_name` 資料堆儲存名稱，留空時自動生成

#####輸出資料
struct array `Dataset`

- `.name` 圖片原本名稱
- `.img` 圖片
- `.corner` 四角位置
- `.up` 「上方」的方向向量

##batchTesting
批次進行圖片對齊測試

> [res, rate]= batchTesting(Dataset, para)

#####輸入資料
- `Dataset` 來自 *batchSetPoints* 取得的結構陣列
- `para` 指定讓所有圖片對第x個對齊，或是輸入任意字串進行交互複雜測試

#####輸出資料
- struct array `res`
 - `.fix` 對齊之基準的圖片名稱
 - `.mov` 對齊時測試圖的圖片名稱
 - `.success` 對其成功與否
 - `.errVal` 誤差值
 - `transPts` 程式估算對齊回來之四點座標
 - `transUp` 程式估算對齊回來之上方方向向量
- `rate` 準確率，會直接輸出在螢幕上

######對齊函式
暫時是調動`imgRegistration`函式

######內部參數
function `testing` 指定對其成功與否的判定式

```
function [Suc, Err, transPoints]= testing(patIdx, sampleIdx)
   %-取得對應後的座標點位置-----------
   info= imgRegistration(Dataset(patIdx).img, Dataset(sampleIdx).img);
   transPoints= transformPointsForward(info.tform, Dataset(sampleIdx).corner);
   
   %-對應成功T/F判定、---------------
   Err= norm(transPoints-Dataset(patIdx).corner);
   Suc= Err < 40;
   
end
```


##imgRegistration
圖片對齊