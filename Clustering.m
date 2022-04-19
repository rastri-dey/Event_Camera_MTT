%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feature            : Event Based Target Clustering
% Author             : Rastri Dey
% Date               : 03/06/2022
% Version            : 1.0
% Matlab Version     : R2021a
% Purpose            : Nearest Neighbor based Event clustering 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [EventXCluster,EventYCluster,EventTCluster,ClusterNum] = Clustering(DataX,DataY,DataT)
Len_DataX=length(DataX);           %sizeof of datapoints per timestamp
DataX_Cluster = cell(1);           %Initialize the variable to store x-coordinate (pix) of the cluster in cell type
DataY_Cluster = cell(1);           %Initialize the variable to store y-coordinate (pix) of the cluster in cell type
DataT_Cluster = cell(1); 
radius_thr = 50;                   %Initialize the variable for radius threshold
EventXCluster = cell(1);           % Final Event X Cluster
EventYCluster = cell(1);           % Final Event Y Cluster
EventTCluster = cell(1);
%% Nearest Neighbor: Euclidean Distance Based
radius_flag = -1*ones(Len_DataX,Len_DataX);
dist= -1*ones(Len_DataX,Len_DataX);
ClusterId = 1;
while(~isempty(DataX))
    for col = 1:(length(DataX))
        dist(ClusterId,col)=sqrt((DataX(col)-DataX(1))^2+(DataY(col)-DataY(1))^2);
        if dist(ClusterId,col)>=   radius_thr %radius_threshold;
            radius_flag(ClusterId,col)=1;
        else
            radius_flag(ClusterId,col)=0;
        end
    end
    % Find Dense regions
    DataX_Cluster{ClusterId} = DataX((radius_flag(ClusterId,:)==0));
    DataY_Cluster{ClusterId} = DataY((radius_flag(ClusterId,:)==0));
    DataT_Cluster{ClusterId} = DataT((radius_flag(ClusterId,:)==0));
    % Accumulate dense cluster points
    DataX = DataX((radius_flag(ClusterId,:)==1));
    DataY = DataY((radius_flag(ClusterId,:)==1));
    ClusterId = ClusterId+1;    
end

clstr = 0;
for c = 1: length(DataX_Cluster)
   if  length(DataX_Cluster{c}) > 3             % Ignore the clusters having less than 4 datapoints
       clstr = clstr+1;
       EventXCluster{clstr} = DataX_Cluster{c};
       EventYCluster{clstr} = DataY_Cluster{c};
       EventTCluster{clstr} = DataT_Cluster{c};
   end
end
ClusterNum = length(EventXCluster);             % Number of Clusters in current timestamp

