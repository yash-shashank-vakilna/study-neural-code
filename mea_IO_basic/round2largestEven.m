function [n] = round2largestEven (n)
%Round to largest even

if mod(n,2) == 1
    n = n+1;
end

end

