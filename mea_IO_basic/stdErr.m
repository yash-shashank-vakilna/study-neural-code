function [SE] = stdErr(x,dim)
%calculates Std Err
if not(exist('dim','var'))
    dim=1;
end
SE = std(x,0,dim)/sqrt(size(x,dim));
end

