%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   demoSIM
%   A demo of Shape Interactive Matrix based mismatch removal on synthetic dataset.
%   Variance:
%       TotalNum: total number of putative matches
%       WrongNum: number of the false matches
%       X:        coordinate of the points in the first set
%       Y:        coordinate of the points in the second set
%       T:        affine transformation between the two sets
%       FalseIdx_GT: the ground truth indices of the false matches
%       TrueIdx_GT: the ground truth indices of the True matches
%
%   Authors: 
%       Yang Lin (linyang@cis.pku.edu.cn)
%   Date:
%       11/24/2016
%   Reference:
%       Yang Lin; Zhouchen Lin; Hongbin Zha, "The Shape Interaction Matrix Based Affine Invariant Mismatch Removal for Partial-Duplicate Image Search,"
%       in IEEE Transactions on Image Processing, 2016
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Repeat the experiments by one hundred times
    F1=zeros(100,1);
    TimeCost=zeros(100,1);
    for i=1:100
    %%  Settings
        OutlierMagnitude = 1;
        OutlierPercent   = 0.1;
        TotalNum = 1e3;
        FalseNum = TotalNum * OutlierPercent;
    %%  Generate the coordinate of the two point sets under an affine transformation with outliers (mismatches).
        X = rand(TotalNum,2);
        T = rand(2,2);
        Y = (T * X')';
        FalseInd=randi(TotalNum,FalseNum,1);
        TrueInd=setdiff(1:TotalNum,FalseInd);
        Y(FalseInd,:)=rand(FalseNum,2)*OutlierMagnitude;
    %%  Compute the centered and scaled version of two coordinates.
        nX=[zscore(X) ones(TotalNum,1)]';
        nY=[zscore(Y) ones(TotalNum,1)]';
    %%  Find the true matches by our method "SIM".
        tic;
        TrueInd_SIM=SIM(nX,nY);
        TimeCost(i)=toc;
    %%  Compute the precision and recall of our method on detecting the true matches.
        P=length(intersect(TrueInd,TrueInd_SIM))./length(TrueInd_SIM);
        R=length(intersect(TrueInd,TrueInd_SIM))./length(TrueInd);
        F1(i)=2*(P*R)/(P+R);
    %%  Display the results
        disp(['No.' num2str(i) '-average F1:' num2str(F1(i)) ' average time cost:' num2str(TimeCost(i)) 's']);
    end
%%  Compute and display the average f1-score and average time cost.
    AverageF1=mean(F1);
    AverageTimeCost=mean(TimeCost);
    disp({'F1-score'     ,'Timecost'     ;...
           num2str(AverageF1),[num2str(AverageTimeCost) 's'];})