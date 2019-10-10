function [SE] = stdErr(x,dim)
%calculates Std Err
if ~(exist('dim','var'))
    dim=2;
end
SE = std(x,0,dim)/sqrt(size(x,dim));
end

