%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feature            : State Estimation
% Author             : Rastri Dey
% Date               : 03/14/2022
% Version            : 1.0
% Matlab Version     : R2021a
% Purpose            : State and covariance Update 
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [state_updt,Pupdt]=StateEstimation(state_pred,Ppred,S,InnovCov,V,Beta)
H = [1 0 0 0; 0 0 1 0];                                                     % Sensor Model
Filter_Gain = Ppred*H'*inv(S);              % Filter Gain
P2 = Ppred-(Filter_Gain*S*Filter_Gain');    % Component for Covariance Update Term
P3 = Filter_Gain*InnovCov*Filter_Gain';        % Component for Covariance Update Term

state_updt = state_pred + (Filter_Gain*V);  % State Update
Pupdt = Beta(1)*Ppred +((1-Beta(1))*P2)+P3; % Covariance Update
