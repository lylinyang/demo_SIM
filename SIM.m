function TrueInd=SIM(X,Y)
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   SIM - Shape Interactive Matrix based Mismatch Removal:
%   Detect the mismatches between two point sets.
%   Input:
%       X,Y: The coordinate of the two point sets.
%   Output:
%       TrueInd: The indices of the detected true matches.
%
%   Authors: 
%       Yang Lin (linyang@cis.pku.edu.cn)
%   Date:
%       11/24/2016
%   Reference:
%       Yang Lin; Zhouchen Lin; Hongbin Zha, "The Shape Interaction Matrix Based Affine Invariant Mismatch Removal for Partial-Duplicate Image Search,"
%       in IEEE Transactions on Image Processing, 2016
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compute the shape interactive matrices (SIM) of the two point sets
    Z1=X'*((X*X')\X);
    Z2=Y'*((Y*Y')\Y);
%% Compute the corruptions between each row of two SIMs by using the cosine distance.
    CosDist=-sum(Z1.*Z2,2)./sqrt(sum(Z1.^2,2))./sqrt(sum(Z2.^2,2));
%% Sort the cosine distance to find the "turning point", and take its distance value as a threshold to filter the mismatches.
    [SortCosDist,SortInd]=sort(CosDist,'descend');
    v1=(SortCosDist-SortCosDist(end))./(SortCosDist(1)-SortCosDist(end));
    v2=(0:1/(size(X,2)-1):1)';
    [~,TurningPoint]=min((v1.^2)+1*(v2.^2));
%%  Obtain the indices of the detected true matches, whose cosine distance value is lower than that of the "turning point".
    TrueInd=SortInd(TurningPoint:end);
end