%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feature            : State Prediction
% Author             : Rastri Dey
% Date               : 03/14/2022
% Version            : 1.0
% Matlab Version     : R2021a
% Purpose            : State Prediction using assumed motion model from
%                      Sample Time k-1 to k
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Zpred,state_pred,Ppred,Innovation]=Prediction(state_updt,Pupdt)
Q=1*eye(4);
R=eye(2);
dT=0.003;                                           % Sample Time = 25ms approx.
F=[1 dT 0 0;0 1 0 0;0 0 1 dT;0 0 0 1];              % State Transition Matrix: Motion Model
H = [1 0 0 0; 0 0 1 0];                             % Measurement Model

    state_pred=F*state_updt;                        % State Prediction
    Ppred=F*Pupdt*F'+Q;                             % Covariance Prediction
    Zpred=H*state_pred;                             % Measurement Prediction
    Innovation=H*Ppred*H'+R;                        % Innovation Covariance