%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feature            : Multi Target Tracking with Event Camera
% Author             : Rastri Dey
% Date               : 03/06/2022
% Version            : 1.0
% Matlab Version     : R2021a
% Purpose            : To simulate multiple target, object detection and
%                      tracking based on future prediction of object with
%                      constant velocity and acceleration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear;close all
format long;

%% Load Dataset
dataset_name = "shapes_rot";        % Choices: "shapes_rot" (Use),"shapes_trans" , "shapes_6dof"
EC = EC_dataset(dataset_name);

% Initialization
MTT.EventCount = 0;
MTT.TrajX = cell(1);
MTT.TrajY = cell(1);
MTT.ClstrTraj = cell(1);

% Main Loop: For all Event Times
for k = 1:100:size(EC.DataT,1)
    if(EC.DataT.(1)(k)<10)                                          % Run for 10 seconds
        
        % Accumulate Events
        MTT.EventCount = MTT.EventCount + 1;
        MTT.DataX = EC.DataX.(1)(k:k+99);
        MTT.DataY = EC.DataY.(1)(k:k+99);
        MTT.DataP = EC.DataP.(1)(k:k+99);
        MTT.DataT = EC.DataT.(1)(k:k+99);
        EventData = plot(MTT.DataX,MTT.DataY,'ob');grid on;hold on;          % Raw Data
        
        %% Event Based Clustering (Nearest Neighbour)
        
        [MTT.Cluster.DataX, MTT.Cluster.DataY, MTT.Cluster.DataT, MTT.Cluster.ClusterNum] = Clustering(MTT.DataX,MTT.DataY,MTT.DataT);
        
        for c = 1:MTT.Cluster.ClusterNum
            text(MTT.Cluster.DataX{c}(1),MTT.Cluster.DataY{c}(1),strcat('C-',num2str(c)),'FontSize',10,'FontWeight','bold')
        end
        % Feature Extraction
        [MTT.Obstacle.X, MTT.Obstacle.Y]= FeaturePt(MTT.Cluster.DataX,MTT.Cluster.DataY);
        Feature_Pt = plot(MTT.Obstacle.X, MTT.Obstacle.Y,'*r');grid on;hold on;
        
        %% PDAF Filtering
        MeasurementData = [MTT.DataX,MTT.DataY]';
        % For Each Target
        for Target = 1:7                                 % Track Initialization/ Addition
            if k < 2 || Target > size(MTT.pdaf.State,2)
                MTT.Obstacle.Vx(Target) = 0;
                MTT.Obstacle.Vy (Target) = 0;
                MTT.pdaf.State(:,Target) = [MTT.Obstacle.X(Target); MTT.Obstacle.Vx(Target); MTT.Obstacle.Y(Target); MTT.Obstacle.Vy(Target)];
                MTT.pdaf.NumState = size(MTT.pdaf.State,1);
                
                MTT.pdaf.Cov{Target} = eye(MTT.pdaf.NumState);
                
                [MTT.pdaf.State(:,Target),MTT.pdaf.xpredict(Target),MTT.pdaf.ypredict(Target),MTT.pdaf.Cov{Target}, ellipse] = pdaf...
                    (MTT.pdaf.State(:,Target), MeasurementData, MTT.pdaf.Cov{Target});
                
                ValidationGate = plot(ellipse(1,:)+MTT.pdaf.xpredict(Target), ellipse(2,:)+MTT.pdaf.ypredict(Target),'r');hold on;
                text(MTT.pdaf.xpredict(Target)+4,MTT.pdaf.ypredict(Target)+4,strcat('TID -',num2str(Target)),'FontSize',10,'FontWeight','bold')
                
            else                % Target Tracking for existing Tracks
                [MTT.pdaf.State(:,Target),MTT.pdaf.xpredict(Target),MTT.pdaf.ypredict(Target),MTT.pdaf.Cov{Target}, ellipse] = pdaf...
                    (MTT.pdaf.State(:,Target), MeasurementData, MTT.pdaf.Cov{Target});
                
                ValidationGate = plot(ellipse(1,:)+MTT.pdaf.xpredict(Target), ellipse(2,:)+MTT.pdaf.ypredict(Target),'r'); hold on;
                text(MTT.pdaf.xpredict(Target)+4,MTT.pdaf.ypredict(Target)+4,strcat('TID -',num2str(Target)),'FontSize',10,'FontWeight','bold')
                
            end
        end
        MTT.TrajX{MTT.EventCount} = MTT.pdaf.xpredict;          % X Trajectory per obstacle per event timestamp
        MTT.TrajY{MTT.EventCount} = MTT.pdaf.ypredict;          % Y Trajectory per obstacle per event timestamp
        MTT.ClstrTraj{MTT.EventCount} = MTT.Cluster.ClusterNum; % Number of clusters per event timestamp
        
        MTT.GtX{MTT.EventCount} = MTT.Obstacle.X;
        MTT.GtY{MTT.EventCount} = MTT.Obstacle.Y;
        
        
        text(min(MTT.pdaf.xpredict)-10,max(MTT.pdaf.ypredict)+10,strcat('Time(ms): ',num2str(MTT.DataT(1)*1e3)),'FontSize',10,'FontWeight','bold');
        legend('Raw Event Data','Feature Point','Validation Gate','location','northeast');
        xlabel('X_ (body), pix');
        ylabel('Y_ (body), pix');
        title('Multiple Target Tracking for Events in camera frame');
        hold off;
        disp(k);
        pause(2)        % For visulaizing the plots
        
    else
        break;
    end
end

