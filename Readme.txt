/////////////////////////////////////////////////
//                網通原Lab2                   //
//                                             //
//                                             //
/////////////////////////////////////////////////

一、程式列表
    1. BPSK.m
    2. BPSK0to10.m

二、程式功能說明
    1. BPSK.m
       包含spec上的Step1到Step6，
       將Eb固定為2，input data固定為10000bits， 
       Modulate時有乘上phi1，Demodulate時有對s(t)做積分。
       程式執行後，會output採樣出的Sample_BER(一個數) 

    2. BPSK0to10.m
       包含spec上的Step7，
       將Eb設為0到10，依照spec的Hint4做modulate跟demodulate
       程式執行後，會output一張圖，
       圖上有用公式得出理論BER之曲線，以及採樣出的Sample_BER之資料點

三、程式開啟方式
    1a.開啟Matlab，並將此資料夾加入執行路徑
    1b.在command line輸入"BPSK"，以執行程式
    1c.等待程式執行(約15至20分鐘)
    1d.程式執行後會產生一個數，就是採樣出的Sample_BER
    
    2a.在command line輸入"BPSK0to10"，以執行程式
    2b.等待程式執行(約2.5小時)
    2c.程式執行後會產生一張圖，包含理論BER之曲線以及Sample_BER之資料點
