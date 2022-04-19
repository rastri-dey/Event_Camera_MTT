%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feature            : Data Association
% Author             : Rastri Dey
% Date               : 03/14/2022
% Version            : 1.0
% Matlab Version     : R2021a
% Purpose            : Data Association based on Likelihood of the data
%                      within the volume of n-dimenional unit hypersphere
%                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [InnovCov,V,Beta]=DataAssociation(Gamma,numvalidMeas,ZError,ValidMeas,S,Zpred)
PD = 0.9;                                                                   % Target Detection Probability
PG = 0.95;                                                                  % Gate Probability 
% Poisson Clutter Model with Spatial Density = numvalidMeas/Volume

Volume = (pi*pi/2)*sqrt((Gamma)^4*(det(S)));      % Volume of Validation Region for 4-dimensional

for k = 1:numvalidMeas
    N = mvnpdf(ValidMeas(:,k),Zpred,S)';
    Likelihood(k)=(Volume/numvalidMeas)*N*PD;   % Likelihood of Measurement Originating from Target Not Clutter
end
Den=(1 - (PG*PD) + sum(Likelihood));            % Denominator
Beta(1) =  (1-PG*PD)/Den;                       % Association Probability
Beta(2:numvalidMeas+1) = Likelihood(1:numvalidMeas)/Den; 
V = (Beta(2:numvalidMeas+1)*ZError')';          % Combined Innovation
BVV = zeros(2,2);
for i= 1:numvalidMeas
    BVV = Beta(i+1)*ZError(:,i) * ZError(:,i)' + BVV;   % Component for spread of Innovation Term
end

InnovCov=BVV - V*V';       % Component for spread of Innovation Term

         