
function [MidPtX,MidPtY] = FeaturePt(DataX,DataY)
% For an Indoor dataset, on analysis it is observed that,
% mean represents the feature points
for c=1:length(DataX)
    MidPtX(c) = mean(DataX{c});
    MidPtY(c) = mean(DataY{c});
end

end