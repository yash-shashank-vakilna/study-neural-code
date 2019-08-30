function [regwiseResult] = formatMEAwise2RegionWise(meawiseResult, col_no)
%Formats mea-wise result to regwise reults by concatentating
regwiseResult = cell(1,4);
for regi = 1:4
    for fi = [ 3 4 5 6 7]
        regwiseResult{regi} = [regwiseResult{regi}; cell2mat(meawiseResult{fi}{regi}(:,col_no))];
    end
end
end

