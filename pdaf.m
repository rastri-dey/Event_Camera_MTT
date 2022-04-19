%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feature            : Probabibilistic Data Association Filter
% Author             : Rastri Dey
% Date               : 03/14/2022
% Version            : 1.0
% Matlab Version     : R2021a
% Purpose            : Data Tracking
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function [State,x,y,Cov,ellipse] = pdaf(State,Z,Cov)
                                                                
% State Prediction
[Zpred,State,Cov,Innovation]=Prediction(State,Cov);
Num_Target = size(Z,2);                                                     % Number of Targets
MahaDistance = zeros(Num_Target);

% Measurement Validation
if Num_Target>0
    Diff = -Zpred(:,ones(1,Num_Target)) + Z;
    for i=1:Num_Target
        MahaDistance(1,i)=(Diff(:,i))'/(Innovation)*Diff(:,i);               % Validation Region: Mahalanobis distance^2
    end
    Gamma = 40;
    MahaIndex = MahaDistance(1,:) < Gamma;                                  % Gamma: Gate Threshold
else
    MahaIndex = 0;
end

if sum(MahaIndex)==0                                                        % No Data Matching: No measurement Data Found for existing State (Deletion)
    ValidEvent = Zpred;
    Meas_Error = [0 0]';                                                          % Innovation
    validMeasNum = 0;
else
    ValidEvent = Z(:,MahaIndex);
    Meas_Error = Diff(:,MahaIndex);                                               % Innovation
    validMeasNum = size(ValidEvent,2);
end

if validMeasNum>0
    
    % Data Association
    [InnovCov,V,Beta] = DataAssociation(Gamma,validMeasNum,Meas_Error,ValidEvent,Innovation,Zpred);
    
    % State Update
    [State,Cov] = StateEstimation(State,Cov,Innovation,InnovCov,V,Beta);
end

x = State(1);           % X position Pixel
y = State(3);           % Y position Pixel

%% Draw Ellipse for Valid Events corresponding to targets
X = ValidEvent';
% Sample mean
mu = (1/validMeasNum * sum(X))'; % transpose to make it a column vector
% Sample covariance
e = (X - mu')'; 
Sigma = (e * e') / (validMeasNum-1);
[L, flag] = chol(Sigma, 'lower');

% create points from a unit circle
phi = (-pi:.01:pi)';
circle = [cos(phi), sin(phi)];

% % create confidence ellipse: Chi-squared 2-DOF 95% percent confidence (0.05): 5.991
scale = sqrt(5.991);

% if Sigma is positive definite plot the ellipse
if ~flag
    
    % apply the transformation and scale of the covariance
    ellipse = (scale * L * circle');
    
else
    ellipse = (scale * eye(2) * circle'); %Innovation
end

