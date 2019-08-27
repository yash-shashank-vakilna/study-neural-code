function [ concatenated_mea ] = concatenate_mea( mea1, mea2 )
%concatenates mea1 and mea2
fields1 = fieldnames(mea1);
fields2 = fieldnames(mea2);
concatenated_mea = struct();
for fi = 1:length(fields1)
    if(any(strcmpi(fields1(fi), fields2)))
        fname = fields1{fi};
        eval(sprintf('concatenated_mea.%s = [mea1.%s; mea2.%s];',fname,fname,fname));
    end
end 

end

